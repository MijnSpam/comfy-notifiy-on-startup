# Put this 1 or more of these scripts into your comfy /userscripts_dir folder
## Any script on linux needs to be made executable by chmod +x <filename>

A restart from the comfyUI manager will not trigger this start script. When you run ComfyUI in a container. A container restart will trigger it.<br>
A hard processing failure which triggers a restart of the container will also do this.

### 00-on_restart-pushover.sh
Looks for an .env file in the same folder. see example file but rename it to .env when using this script.
Possible pushover sounds: "pushover", "bike", "bugle", "cashregister", "classical", "cosmic", "falling", "gamelan", "incoming", "intermission", "magic", "mechanical", "pianobar", "siren", "spacealarm", "tugboat", "alien", "climb", "persistent", "echo", "updown", "vibrate", "none"
