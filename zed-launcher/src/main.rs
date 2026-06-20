use eframe::egui;
use fuzzy_matcher::FuzzyMatcher;
use fuzzy_matcher::skim::SkimMatcherV2;
use std::env::var;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::os::unix::net::{UnixListener, UnixStream};
use std::io::{Read, Write};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

fn socket_path() -> PathBuf {
    std::env::temp_dir().join("zed-launcher.sock")
}

fn try_notify_existing_instance() -> bool {
    let path = socket_path();
    match UnixStream::connect(&path) {
        Ok(mut stream) => {
            let _ = stream.write_all(b"show");
            true
        }
        Err(_) => false,
    }
}

fn spawn_listener(show_requested: Arc<AtomicBool>, ctx: egui::Context) {
    let path = socket_path();
    let _ = fs::remove_file(&path);

    let listener = match UnixListener::bind(&path) {
        Ok(l) => l,
        Err(e) => {
            eprintln!("failed to bind socket: {e}");
            return;
        }
    };

    std::thread::spawn(move || {
        for stream in listener.incoming().flatten() {
            handle_connection(stream);
            show_requested.store(true, Ordering::SeqCst);
            ctx.request_repaint();
        }
    });
}

fn handle_connection(mut stream: UnixStream) {
    let mut buf = [0u8; 4];
    let _ = stream.read(&mut buf);
}

struct Entry {
    name: String,
    path: PathBuf,
    is_dir: bool,
}

fn resolve_login_path() -> Option<String> {
    let shell = var("SHELL").unwrap_or_else(|_| "/bin/zsh".to_string());

    let output = Command::new(shell).args(["-l", "-c", "echo $PATH"]).output().ok()?;

    if output.status.success() {
        let path = String::from_utf8_lossy(&output.stdout).trim().to_string();
        if !path.is_empty() {
            return Some(path)
        }
    }
    None
}

struct App {
    current_dir: PathBuf,
    entries: Vec<Entry>,
    selected: usize,
    page: usize,
    input: String,
    login_path: Option<String>,
    show_requested: Arc<AtomicBool>,
}

const PAGE_SIZE: usize = 10;

impl App {
    fn new(show_requested: Arc<AtomicBool>) -> Self {
        let current_dir: PathBuf = var("HOME").unwrap().into();
        Self {
            entries: list_contents(&current_dir),
            current_dir,
            selected: 0,
            page: 0,
            input: String::new(),
            login_path: resolve_login_path(),
            show_requested,
        }
    }

    fn reset(&mut self) {
        self.current_dir = var("HOME").unwrap().into();
        self.entries = list_contents(&self.current_dir);
        self.selected = 0;
        self.page = 0;
        self.input.clear();
    }
}

impl eframe::App for App {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {

        if self.show_requested.swap(false, Ordering::SeqCst) {
                log("show requested, making visible");
            self.reset();
            ctx.send_viewport_cmd(egui::ViewportCommand::Visible(true));
            ctx.send_viewport_cmd(egui::ViewportCommand::Focus);
        }

        if ctx.input(|i| i.viewport().close_requested()) {
            ctx.send_viewport_cmd(egui::ViewportCommand::CancelClose);
            ctx.send_viewport_cmd(egui::ViewportCommand::Visible(false));
        }

        egui::CentralPanel::default().show(ctx, |ui| {
            ctx.set_pixels_per_point(3.0);

            let matcher = SkimMatcherV2::default();

            let mut matches: Vec<(&Entry, i64)> = self
                .entries
                .iter()
                .filter_map(|entry| {
                    matcher
                        .fuzzy_match(&entry.name, &self.input)
                        .map(|score| (entry, score))
                })
                .collect();

            matches.sort_by(|a, b| b.1.cmp(&a.1));

            let mut open_path: Option<PathBuf> = None;
            let mut change_dir: Option<PathBuf> = None;

            let mut should_close = false;

            ctx.input_mut(|i| {
                if i.consume_key(egui::Modifiers::NONE, egui::Key::Escape) {
                    should_close = true;
                }

                if i.consume_key(egui::Modifiers::NONE, egui::Key::ArrowDown) {
                    if self.selected + 1 < matches.len() {
                        self.selected += 1;

                        if self.selected >= (self.page + 1) * PAGE_SIZE {
                            self.page += 1;
                        }
                    }
                }

                if i.consume_key(egui::Modifiers::NONE, egui::Key::ArrowUp) {
                    if self.selected > 0 {
                        self.selected -= 1;

                        if self.selected < self.page * PAGE_SIZE {
                            self.page -= 1;
                        }
                    }
                }

                if i.consume_key(egui::Modifiers::NONE, egui::Key::Enter)
                || i.consume_key(egui::Modifiers::NONE, egui::Key::Tab) {
                    if let Some((entry, _score)) = matches.get(self.selected) {
                        if entry.name == "." || !entry.is_dir {
                            open_path = Some(entry.path.clone());
                        } else {
                            change_dir = Some(entry.path.clone());
                        }
                    }
                }
            });

            if should_close {
                ctx.send_viewport_cmd(egui::ViewportCommand::Visible(false));
            }

            let prompt = format!("{} > ", display_path(&self.current_dir));

            ui.horizontal(|ui| {
                ui.label(prompt);
                let response = ui.text_edit_singleline(&mut self.input);

                response.request_focus();

                if response.changed() {
                    self.selected = 0;
                    self.page = 0
                }
            });

            let total_pages = matches.len().div_ceil(PAGE_SIZE);

            if self.page >= total_pages {
                self.page = total_pages.saturating_sub(1);
            }

            let start = self.page * PAGE_SIZE;
            let end = (start + PAGE_SIZE).min(matches.len());

            let page_matches = &matches[start..end];

            let local_selected = self.selected.saturating_sub(start);
            let local_selected = local_selected.min(page_matches.len().saturating_sub(1));

            for (i, (entry, _score)) in page_matches.iter().enumerate() {
                let label = if entry.is_dir {
                    format!("{}/", entry.name)
                } else {
                    entry.name.clone()
                };

                let is_selected = i == local_selected;

                let response = ui.selectable_label(is_selected, label);

                if response.clicked() {
                    self.selected = start + i;
                }
            }

            if let Some(path) = open_path {
                let mut cmd = Command::new("zeditor");
                cmd.arg(&path);
                if let Some(login_path) = &self.login_path {
                    cmd.env("PATH", login_path);
                }

                match cmd.spawn() {
                    Ok(_) => ctx.send_viewport_cmd(egui::ViewportCommand::Visible(false)),
                    Err(e) => eprintln!("failed to launch zed: {e}"),
                }
            }

            if let Some(path) = change_dir {
                self.current_dir = path;
                self.entries = list_contents(&self.current_dir);
                self.selected = 0;
                self.page = 0;
                self.input.clear();
            }
        });
    }
}

fn display_path(path: &Path) -> String {
    let home = var("HOME").ok();

    if let Some(home) = home {
        if let Ok(stripped) = path.strip_prefix(&home) {
            return format!("~/{}", stripped.display());
        }
    }

    path.display().to_string()
}

fn list_contents(path: &Path) -> Vec<Entry> {
    let entries = match fs::read_dir(path) {
        Ok(entries) => entries,
        Err(e) => {
            eprintln!("Failed to read directory: {e}");
            return Vec::new();
        }
    };

    let mut dirs = Vec::new();
    let mut files = Vec::new();

    for entry in entries.flatten() {
        let path = entry.path();

        if path.is_dir() {
            dirs.push(Entry {
                name: path.file_name().unwrap().to_string_lossy().into_owned(),
                path: path.clone(),
                is_dir: true,
            })
        } else {
            files.push(Entry {
                name: path.file_name().unwrap().to_string_lossy().into_owned(),
                path: path.clone(),
                is_dir: false,
            });
        }
    }

    dirs.sort_by_key(|entry| entry.name.to_lowercase());
    files.sort_by_key(|entry| entry.name.to_lowercase());

    let mut result = vec![
        Entry {
            name: ".".into(),
            path: path.to_path_buf(),
            is_dir: true,
        },
        Entry {
            name: "..".into(),
            path: path.parent().unwrap_or(path).to_path_buf(),
            is_dir: true,
        },
    ];

    dirs.extend(files);
    result.extend(dirs);

    result
}

fn main() -> eframe::Result<()> {
    log("main start");
    if try_notify_existing_instance() {
        log("notified existing instance, exiting");
        return Ok(());
    }
    log("no existing instance, becoming server");

    let show_requested = Arc::new(AtomicBool::new(false));

    let mut options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([300.0, 375.0])
            .with_resizable(false),
       ..Default::default()
    };

    #[cfg(target_os = "macos")]
    {
        use winit::platform::macos::{ActivationPolicy, EventLoopBuilderExtMacOS};
        options.event_loop_builder = Some(Box::new(|builder| {
            builder.with_activation_policy(ActivationPolicy::Accessory);
        }));
    }

    eframe::run_native(
        "Zed Launcher",
        options,
        Box::new(move |cc| {
            spawn_listener(show_requested.clone(), cc.egui_ctx.clone());
            Ok(Box::new(App::new(show_requested)))
        }),
    )
}

fn log(msg: &str) {
    use std::io::Write;
    if let Ok(mut f) = std::fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open("/tmp/zed-launcher.log")
    {
        let _ = writeln!(f, "{msg}");
    }
}
