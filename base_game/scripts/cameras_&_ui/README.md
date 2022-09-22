# Cameras & UI
This folder contains all scripts for cameras, viewports, menu elements and hud elements.

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
This is the script for the root node of [main.tscn](/base_game/scenes/cameras_&_ui/main.tscn). It controls the main menu.

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

### Property Descriptions
#### - Spatial track
This is the current race track, or the upcoming track, if the next round has not yet started.

#### - bool resources_loaded
Default: false<br>
This bool is true, if the [always_loaded](#--onready-array-always_loaded) resources have been loaded.

#### - bool new_track_instantiated
Default: false<br>
This bool is true, if the next round has been prepared in the [thread](#--onready-thread-thread).

#### - onready Array always_loaded
On ready, this Array contains the paths to all resources, that should always be loaded. Later, the paths are replaced by the actual resources themselves.

#### - onready Thread thread
This Thread is used to prepare the next round.

### Method Descriptions
#### - void _ready()

## msaa_viewport.gd

## player_container.gd

## resizing_arrow.gd

## resizing_control_font.gd

## vehicle_select.gd
