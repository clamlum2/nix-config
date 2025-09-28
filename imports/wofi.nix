{ ... }:

{
  home.file.".config/wofi/config".text = ''
    [config]
    allow_images=true
    width=500
    show=drun
    prompt=Search
    height=400
    term=kitty
    hide_scroll=true
    print_command=true
    insensitive=true
    columns=1
    no_actions=true
  '';

  home.file.".config/wofi/style.css".text = ''
    @define-color foreground #e0e0e0;
    @define-color background #0d1520;
    @define-color cursor #e0e0e0;

    @define-color color0 #000000;
    @define-color color1 #fb0120;
    @define-color color2 #a1c659;
    @define-color color3 #fda331;
    @define-color color4 #6fb3d2;
    @define-color color5 #d381c3;
    @define-color color6 #76c7b7;
    @define-color color7 #e0e0e0;
    @define-color color8 #b0b0b0;
    @define-color color9 #fb0120;
    @define-color color10 #a1c659;
    @define-color color11 #fda331;
    @define-color color12 #6fb3d2;
    @define-color color13 #d381c3;
    @define-color color14 #76c7b7;
    @define-color color15 #ffffff;
    @keyframes fadeIn {
        0% {
        }
        100% {
        }
    }

    * {
        all:unset;
        font-family: 'CodeNewRoman Nerd Font Mono', monospace;
        font-size: 18px;
        outline: none;
        border: none;
        text-shadow:none;
        background-color:transparent;
    }

    window {
        all:unset;
        padding: 20px;
        border-radius: 10px;
        background-color: alpha(@background,.8);
    }
    #inner-box {
        margin: 2px;
        padding: 5px
        border: none;
    }
    #outer-box {    
        border: none;
    }
    #scroll {
        margin: 0px;
        padding: 30px;
        border: none;
    }
    #input {
        all:unset;
        margin-left:20px;
        margin-right:20px;
        margin-top:20px;
        padding: 20px;
        border: none;
        outline: none;
        color: @text;
        box-shadow: 1px 1px 5px rgba(0,0,0, .5);
        border-radius:10;
        background-color: alpha(@background,.2);
    }
    #input image {
        border: none;
        color: @blue;
        padding-right:10px;
    }
    #input * {
        border: none;
        outline: none;
    }

    #input:focus {
        outline: none;
        border: none;

        border-radius:10;
    }
    #text {
        margin: 5px;
        border: none;
        color: @text;
        outline: none;
    }
    #text {
        margin: 5px;
        border: none;
        color: @text;
        outline: none;
    }
    #entry {
        border: none;
        margin: 5px;
        padding: 10px;
    }
    #entry arrow {
        border: none;
        color: @lavender;

    }
    #entry:selected {
        box-shadow: 1px 1px 5px rgba(255,255,255, .03);
        border: none;
        border-radius: 20px;
        background-color:transparent;
    }
    #entry:selected #text {
        color: @blue;
    }
    #entry:drop(active) {
        background-color: @lavender !important;
    }

  '';
}
