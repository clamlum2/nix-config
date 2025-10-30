{ ... }:

{
    programs.wofi ={ 
        enable = true;
        settings = {
            allow_images = true;
            width = 500;
            show = "drun";
            prompt = "Search";
            height = 400;
            term = "ghostty";
            hide_scroll = true;
            print_command = true;
            insensitive = true;
            columns = 1;
            no_actions = true;
        };
    };

    home.file.".config/wofi/style.css".text = ''
        @define-color foreground #ffffff;
        @define-color background #0d1520;
        @define-color cursor #ffffff;
        @define-color blue #57f7fc;
        @define-color blue2 #579599;

        @keyframes fadeIn {
            0% {
            }
            100% {
            }
        }

        * {
            all:unset;
            font-family: 'DejaVuSansM Nerd Font Mono', monospace;
            font-size: 18px;
            outline: none;
            border: none;
            text-shadow:none;
            background-color:transparent;
        }

        window {
            all:unset;
            padding: 20px;
            border: 1px solid @blue;
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
            color: @foreground;
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
            border: 1px solid @blue2;

            border-radius:10;
        }
        #text {
            margin: 5px;
            border: none;
            color: @foreground;
            outline: none;
        }
        #text {
            margin: 5px;
            border: none;
            color: @foreground;
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
            border: 1px solid @blue;
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
