# Destruction
This folder contains various Scripts, related to destruction.

### Contents
[destructible](#destructiblegd)<br>
[explosion](#explosiongd)<br>
[sparks](#sparksgd)<br>

## destructible.gd
extends Area<br>
This is the Script of the root Node of a destructible Scene.

### Properties
| Type | Name |
|---|---|
| String | [parts_path](#--export-string-parts_path) |
| bool | [global_culling](#--export-bool-global_culling) |
| bool | [destroyed](#--bool-destroyed) |
| Node | [deletion_manager](#--node-deletion_manager) |
| PackedScene | [parts](#--packedscene-parts) |

### Methods
| Return Type | Name |
|---|---|
| void | [_ready()](#--void-_ready) |
| void | [destroy(var vehicle: [CombatVehicle], var position: Vector3, var force: float)](#--void-destroyvar-vehicle-combatvehicle-var-position-vector3-var-force-float) |
| void | [_on_Area_body_entered(body)](#--void-_on_area_body_enteredbody) |
| void | [_on_VisibilityNotifier_screen_entered()](#--void-_on_visibilitynotifier_screen_entered) |
| void | [_on_VisibilityNotifier_screen_exited()](#--void-_on_visibilitynotifier_screen_exited) |

### Property Descriptions
#### - export String parts_path
Default: "res://scenes/destruction/rock_0_destroyed.tscn"<br>
This is the path, to the destroyed version of this scene.

#### - export bool global_culling
Default: false<br>
This bool is true, if the scene is not part of a room.

#### - bool destroyed
Default: false<br>
This bool is true, if this scene was destroyed.

#### - Node deletion_manager
This is the DeletionManager of the current track.

#### - PackedScene parts
This is the destroyed version of this scene.

### Method Descriptions
#### - void _ready()
This method loads the [parts](#--packedscene-parts), using [parts_path](#--export-string-parts_path). Then, if [global_culling](#--export-bool-global_culling) is true, it sets the portal_mode of the MeshInstance and VisibilityNotifier th global.

#### - void destroy(var vehicle: [CombatVehicle], var position: Vector3, var force: float)
This method checks, if this scene is already [destroyed](#--bool-destroyed). If false, it instantiates [parts](#--packedscene-parts) ...

#### - void _on_Area_body_entered(body)
This method ...

#### - void _on_VisibilityNotifier_screen_entered()
This method ...

#### - void _on_VisibilityNotifier_screen_exited()
This method ...
