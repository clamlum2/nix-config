use egui::Key;
use egui::Modifiers;
use fuzzy_matcher::FuzzyMatcher;
use fuzzy_matcher::skim::SkimMatcherV2;
use std::fs;
use std::io::{Read, Write};
use std::os::unix::net::{UnixListener, UnixStream};
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::Arc;
use std::sync::atomic::{AtomicBool, Ordering};
use which::which;

use eframe::egui;

fn open_existing_instance() -> bool {
    let path = std::env::temp_dir().join("zed-launcher.sock");
    match UnixStream::connect(&path) {
        Ok(mut stream) => {
            let _ = stream.write_all(b"show");
            true
        }
        Err(_) => false,
    }
}

struct Entry {
    name: String,
    path: PathBuf,
    is_dir: bool,
}

struct App {
    current_dir: PathBuf,
    entries: Vec<Entry>,
    selected: usize,
    page: usize,
    input: String,
    show_requested: Arc<AtomicBool>,
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

        if path.file_name().unwrap().to_string_lossy().into_owned() == ".DS_Store" {
            continue;
        }

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

impl App {
    fn new(show_requested: Arc<AtomicBool>) -> Self {
        let current_dir: PathBuf = std::env::var("HOME").unwrap().into();
        Self {
            entries: list_contents(&current_dir),
            current_dir,
            selected: 0,
            page: 0,
            input: String::new(),
            show_requested,
        }
    }

    fn reset(&mut self) {
        self.current_dir = std::env::var("HOME").unwrap().into();
        self.entries = list_contents(&self.current_dir);
        self.selected = 0;
        self.page = 0;
        self.input.clear();
    }
}

fn display_path(path: &Path) -> String {
    let home = std::env::var("HOME").ok();

    if let Some(home) = home {
        if let Ok(stripped) = path.strip_prefix(&home) {
            return format!("~/{}", stripped.display());
        }
    }

    path.display().to_string()
}

fn resolve_binary_path(binary_name: &str) -> Option<String> {
    match which(binary_name) {
        Ok(binary_path) => Some(binary_path.to_string_lossy().to_string()),
        Err(e) => {
            eprintln!("Failed to find binary: {}", e);
            None
        }
    }
}

impl eframe::App for App {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        if self.show_requested.swap(false, Ordering::SeqCst) {
            println!("making window visible");
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

            let mut matches: Vec<(&Entry, i64)> = self
                .entries
                .iter()
                .filter_map(|entry| {
                    SkimMatcherV2::default()
                        .fuzzy_match(&entry.name, &self.input)
                        .map(|score| (entry, score))
                })
                .collect();

            matches.sort_by(|a, b| b.1.cmp(&a.1));

            let mut should_close = false;

            let mut open_path: Option<PathBuf> = None;
            let mut change_dir: Option<PathBuf> = None;

            ctx.input_mut(|i| {
                if i.consume_key(Modifiers::NONE, Key::Escape) {
                    should_close = true;
                }

                if i.consume_key(Modifiers::NONE, Key::ArrowDown) {
                    if self.selected < 9 {
                        self.selected += 1;
                    }
                }

                if i.consume_key(Modifiers::NONE, Key::ArrowUp) {
                    if self.selected > 0 {
                        self.selected -= 1;
                    }
                }

                if i.consume_key(Modifiers::NONE, Key::Enter)
                    || i.consume_key(Modifiers::NONE, Key::Tab)
                {
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
                    self.page = 0;
                }
            });

            for (i, (entry, _score)) in matches.iter().take(10).enumerate() {
                let label = if entry.is_dir {
                    format!("{}/", entry.name)
                } else {
                    entry.name.clone()
                };

                let is_selected = i == self.selected;

                let response = ui.selectable_label(is_selected, label);

                if response.clicked() {
                    self.selected = 1;
                }
            }

            if let Some(path) = open_path {
                let binary_path = match resolve_binary_path("zeditor") {
                    Some(path) => path,
                    _ => {
                        eprintln!("Could not find 'zeditor' binary");
                        return;
                    }
                };

                match Command::new(&binary_path).arg(&path).spawn() {
                    Ok(_) => ctx.send_viewport_cmd(egui::ViewportCommand::Visible(false)),
                    Err(e) => eprintln!("failed to launch {binary_path}: {e}"),
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

fn handle_connection(mut stream: UnixStream) {
    let mut buf = [0u8; 4];
    let _ = stream.read(&mut buf);
}

fn spawn_listener(show_requested: Arc<AtomicBool>, ctx: egui::Context) {
    let path = std::env::temp_dir().join("zed-launcher.sock");
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

fn main() -> eframe::Result<()> {
    if open_existing_instance() {
        println!("connected to existing instance");
        return Ok(());
    }

    println!("no existing instance");

    let show_requested = Arc::new(AtomicBool::new(false));

    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([300.0, 375.0])
            .with_resizable(false),
        ..Default::default()
    };

    eframe::run_native(
        "Zed Launcher",
        options,
        Box::new(move |cc| {
            spawn_listener(show_requested.clone(), cc.egui_ctx.clone());
            Ok(Box::new(App::new(show_requested)))
        }),
    )
}
