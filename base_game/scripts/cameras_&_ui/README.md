# Cameras & UI
This folder contains all Scripts for Cameras, Viewports, menu elements and hud elements.

### Contents
[controller_select](#controller_selectgd)<br>
[current_settings](#current_settingsgd)<br>
[follow_camera](#follow_cameragd)<br>
[main](#maingd)<br>
[msaa_viewport](#msaa_viewportgd)<br>
[player_container](#player_containergd)<br>
[resizing_arrow](#resizing_arrowgd)<br>
[resizing_control_font](#resizing_control_fontgd)<br>
[vehicle_select](#vehicle_selectgd)<br>

## controller_select.gd

## current_settings.gd

## follow_camera.gd

## main.gd
extends Control<br>
This is the Script of the root Node of [main.tscn](/base_game/scenes/cameras_&_ui/main.tscn). It controls the main menu.

### Properties
| Type | Name |
|---|---|
| Spatial | [track](#--spatial-track) |
| bool | [resources_loaded](#--bool-resources_loaded) |
| bool | [new_track_instantiated](#--bool-new_track_instantiated) |
| Array | [always_loaded](#--onready-array-always_loaded) |
| Thread | [thread](#--onready-thread-thread) |

### Methods
| Return Type | Name |
|---|---|
| void | [_ready()](#--void-_ready) |
| void | [_process(_delta)](#--void-_process_delta) |
| void | [prepare()](#--void-prepare) |
| void | [play(player_amount: int)](#--void-playplayer_amount-int) |
| void | [active(var b: bool)](#--void-activevar-b-bool) |
| void | [instantiate_vehicles(var spawns: Array, var first_vehicle: int)](#--void-instantiate_vehiclesvar-spawns-array-var-first_vehicle-int) |
| void | [switch_buttons(var from: BoxContainer, var to: BoxContainer)](#--void-switch_buttonsvar-from-boxcontainer-var-to-boxcontainer) |
| void | [various signal methods](#--void-various-signal-methods) |

### Property Descriptions
#### - Spatial track
This is the current race track, or the upcoming track, if the next round has not yet started.

#### - bool resources_loaded
Default: false<br>
This bool is true, if the [always_loaded](#--onready-array-always_loaded) Resources have been loaded.

#### - bool new_track_instantiated
Default: false<br>
This bool is true, if the next round has been [prepared](#--void-prepare) in the [thread](#--onready-thread-thread).

#### - onready Array always_loaded
On ready, this Array contains the paths to all Resources, that should always be loaded. Later, the paths are replaced by the actual Resources themselves.

#### - onready Thread thread
This Thread is used to prepare the next round.

### Method Descriptions
#### - void _ready()
This method loads any installed mods. Then, it changes the game's background color to black. (This can also be done through the project settings, but a black background is annoying, when editing a scene.) Next, it [prepares](#--void-prepare) the game in the [thread](#--onready-thread-thread). After that, it makes the OnePlayer Button the focused control.

#### - void _process(_delta)
This method checks, if there is any "ui_accept_" Input. If true, it creates a "ui_accept" Input. Then, it does the same for all other ui Inputs. (There are multiple Inputs for each ui action, because some menus should only take Inputs from one specific player. The main menu takes Inputs from all players, so this method combines the different versions of those Inputs into one.) Next, it checks for the "ui_cancel" Input. If true, it [switches to the previous menu](#--void-switch_buttonsvar-from-boxcontainer-var-to-boxcontainer) or quits the game.

#### - void prepare()
This method checks if [resources_loaded](#--bool-resources_loaded) is false. This should only be the case, if the game was just started. In that case, this method should load all Resources from the paths in [always_loaded](#--onready-array-always_loaded) and replace the paths in that Array with the actual Resources. All of those Resources should be PackedScenes. Then, this method instaniates the track and the vehicles for spawn points 7-12. (Those spawn points never have player vehicles.)

#### - void play(player_amount: int)
This method hides the main menu. Then, it waits for the [thread](#--onready-thread-thread). Next, it adjusts the ViewportContainers, based on the player_amount. After that, it adds one or more controller select menus to spawn points. Then, this Node [deactivates itself.](#--void-activevar-b-bool) Next, it may instantiate vehicles at spawn points 2-6, depending on the player_amount.

#### - void active(var b: bool)
This method runs [prepare()](#--void-prepare) in the [thread](#--onready-thread-thread). Then, it makes the OnePlayer Button the focused control. Next, it sets visibility and enables/disables processing of itself. After that, it enables/disables the main menu Buttons. Then, it sets the mouse mode.

#### - void instantiate_vehicles(var spawns: Array, var first_vehicle: int)
This method adds a vehicle to each spawn point of the Array. The order of vehicles is always the same, but where to start in that order depends on the first_vehicle.

#### - void switch_buttons(var from: BoxContainer, var to: BoxContainer)
This method changes the visibility of both Containers, to switch menus. Then, it makes the first Button of the menu the focused Control.

#### - void various signal methods
These methods have different purposes, such as [starting a new round](#--void-playplayer_amount-int) or [switching to a different menu.](#--void-switch_buttonsvar-from-boxcontainer-var-to-boxcontainer)

## msaa_viewport.gd

## player_container.gd

## resizing_arrow.gd

## resizing_control_font.gd

## vehicle_select.gd
