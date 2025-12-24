{ lib, pkgs, colors, ... }@args:
lib.mkModule args "ioga.desktop.wofi" {
  config = { cfg }: {
    environment.systemPackages = with pkgs; [ wofi ];
    home.configFiles."wofi/config".text = ''
      width=900
      height=600
      location=center
      show=drun
      prompt=Search...
      filter_rate=100
      allow_markup=true
      no_actions=true
      halign=fill
      orientation=vertical
      content_halign=fill
      insensitive=true
      allow_images=true
      image_size=35
      gtk_dark=true
    '';
    home.configFiles."wofi/style.css".text = ''
      window {
          margin: 5px;
          border: 5px solid #181926;
          background-color: #${colors.base00};
          border-radius: 15px;
          font-family: "JetBrainsMono";
          font-size: 14px;
        }

        #input {
          all: unset;
          min-height: 36px;
          padding: 4px 10px;
          margin: 4px;
          border: none;
          color: #${colors.base05};
          font-weight: bold;
          background-color: #${colors.base01};
          outline: none;
          border-radius: 15px;
          margin: 10px;
          margin-bottom: 2px;
        }

        #inner-box {
          margin: 4px;
          padding: 10px;
          font-weight: bold;
          border-radius: 15px;
        }

        #outer-box {
          margin: 0px;
          padding: 3px;
          border: none;
          border-radius: 15px;
          border: 5px solid #${colors.base01};
        }

        #scroll {
          margin-top: 5px;
          border: none;
          border-radius: 15px;
          margin-bottom: 5px;
        }

        #text:selected {
          color: #${colors.base01};
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
        }

        #entry {
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
          background-color: transparent;
        }

        #entry:selected {
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
          background: #${colors.base0D};
          background-size: 400% 400%;
        }
    '';
  };
}
