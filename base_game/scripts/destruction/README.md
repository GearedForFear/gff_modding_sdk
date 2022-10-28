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
| void | [destroy(var vehicle: CombatVehicle, var position: Vector3, var force: float)](#--void-destroyvar-vehicle-combatvehicle-var-position-vector3-var-force-float) |
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
This method checks, if this scene is already [destroyed](#--bool-destroyed). If false, it instantiates and applies an impulse to the [parts](#--packedscene-parts), disables itself and queues itself for deletion by the [deletion_manager](#--node-deletion_manager).

#### - void _on_Area_body_entered(body)
This method checks, if the body is a [CombatVehicle]. If true, it [destroys](#--void-destroyvar-vehicle-combatvehicle-var-position-vector3-var-force-float) itself.

#### - void _on_VisibilityNotifier_screen_entered()
Not documented, yet.

#### - void _on_VisibilityNotifier_screen_exited()
Not documented, yet.



## explosion.gd
extends Area<br>
This is the Script of the root Node of [explosion.tscn](/base_game/scenes/destruction/explosion.tscn).

### Properties
| Type | Name |
|---|---|
| PackedScene | [Money](#--const-packedscene-money) |
| float | [damage](#--float-damage) |
| int | [reward](#--int-reward) |
| float | [burn](#--float-burn) |
| [CombatVehicle] | [shooter](#--combatvehicle-shooter) |
| Node | [deletion_manager](#--node-deletion_manager-1) |

### Methods
| Return Type | Name |
|---|---|
| void | [_ready()](#--void-_ready-1) |
| void | [_on_Lifetime_timeout()](#--void-_on_lifetime_timeout) |
| void | [_on_Area_body_entered(body)](#--void-_on_area_body_enteredbody-1) |
| void | [_on_Area_area_entered(body)](#--void-_on_area_area_enteredbody) |

### Property Descriptions
#### - const PackedScene Money
Value: preload("[res://scenes/collectables/money.tscn](/base_game/scripts/collectables/readme.md#moneygd)")<br>
This is the scene of money.

#### - float damage
This is the amount of damage, each vehicle takes, that touches this explosion.

#### - int reward
This is the amount of money instantiated, if the heist_target touches this explosion.

#### - float burn
This is the amount of heat, this explosion may cause. Only some vehicles have a heat value. All others are unaffected. (This game version has no [HeatVehicles].)

#### - [CombatVehicle] shooter
This is the creator of the explosion. (For example, the vehicle that launched the missile, that instantiated this explosion.)

#### - Node deletion_manager
This is the DeletionManager of the current track.

### Method Descriptions
#### - void _ready()
This method sets this Spatial as toplevel. Then, it starts the Animation "rotation".

#### - void _on_Lifetime_timeout()
This method disables this Node and queues it for deletion by the [deletion_manager](#--node-deletion_manager).

#### - void _on_Area_body_entered(body)
This method checks, if the body is a CombatVehicle and if the body is less than six metres away from the explosion. (The second condition should not be necessary, but it helps with incorrect collisions.) If true, it applies an impulse to the body and checks, if the body is the [shooter](#--combatvehicle-shooter). If false, it damages the body.

#### - void _on_Area_area_entered(body)
This method checks, if the body is in the group "destructible". If true, it [destroys](#--void-destroyvar-vehicle-combatvehicle-var-position-vector3-var-force-float)  the body.



## sparks.gd
extends MeshInstance<br>
This is the Script of the root Node of [sparks.tscn](/base_game/scenes/destruction/sparks.tscn).

### Properties
| Type | Name |
|---|---|
| Node | [deletion_manager](#--node-deletion_manager-2) |

### Methods
| Return Type | Name |
|---|---|
| void | [_ready()](#--void-_ready-2) |
| void | [_on_AnimationPlayer_animation_finished(_anim_name)](#--void-_on_animationplayer_animation_finished_anim_name) |
| void | [_on_VisibilityNotifier_screen_exited()](#--void-_on_visibilitynotifier_screen_exited-1) |

### Property Descriptions
#### - Node deletion_manager
This is the DeletionManager of the current track.

### Method Descriptions
#### - void _ready()
This method sets this Spatial as toplevel. Then, it starts the Animation "sparks".

#### - void _on_AnimationPlayer_animation_finished(_anim_name)
This method disables this Node and queues it for deletion by the [deletion_manager](#--node-deletion_manager).

#### - void _on_VisibilityNotifier_screen_exited()
This method disables this Node and queues it for deletion by the [deletion_manager](#--node-deletion_manager).
