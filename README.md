# GFF Modding SDK
This is the official modding SDK of Geared for Fear. The repository is [open source](/LICENSE), including the contents of the base game, that are in this repository. Feel free to use them for your own game. This includes all Scripts of the base game. The full source files of the game's ongoing alpha is free to download (but not under any license) on [itch.io](//gearedforfear.itch.io/geared-for-fear-alpha).<br>

Keep in mind, that the game is currently in alpha, so mods have a high likelyhood of not working in future versions of the game. The repository's main branch may be ahead of the latest release on itch.io. The documentation is largely incomplete and partially outdated. Even when finished, it is meant to be used in combination with [the Engine documentation.](//docs.godotengine.org/en/stable/) Most importantly, other people's mods may contain malicious code. When starting the modified game, that code will run.<br>

Modding Geared for Fear requires [Godot 3](//godotengine.org/download), which is [free and open source.](//godotengine.org/license)

## How to install mods
When starting the game for the first time, it should automatically create a user data folder. This can be found on Windows at:
````
  %APPDATA%\Godot\app_userdata\Geared_for_Fear
````
You can simply copy and paste that path into the Windows search function.<br><br>

On Linux, the path is the following:
````
  ~/.local/share/godot/app_userdata/Geared_for_Fear
````
You can use the terminal command `xdg-open ~/.local/share/godot/app_userdata/Geared_for_Fear` on Ubuntu.<br><br>

~~On both operating systems, the folder is expected contain a folder called "logs" and nothing else.~~ You need to create a new folder called "mods". Any mod just needs to be inside that folder. Mods are loaded, when launching the game.<br>
This repository contains "mod_template.pck" as an example mod. When loaded, it should change the text at the top left of the main menu from "Geared for Fear" to "Modified".
