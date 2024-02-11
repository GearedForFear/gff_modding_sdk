# Collectibles
This folder contains all Scripts for items, that a can be collected.

### Contents
[money](#moneygd)<br>

## money.gd
extends Area<br>
This is the Script of the root Node of [money.tscn](/base_game/scenes/collectables/money.tscn).

### Properties
| Type | Name |
|---|---|
| [CombatVehicle] | [shooter](#--combatvehicle-shooter) |
| [CombatVehicle] | [spawner](#--combatvehicle-spawner) |
| int | [reward](#--int-reward) |
| Node | [deletion_manager](#--node-deletion_manager) |
| float | [speed_divisor](#--float-speed_divisor) |

### Methods
| Return Type | Name |
|---|---|
| void | [_ready()](#--void-_ready) |
| void | [_process(_delta)](#--void-_process_delta) |
| void | [_on_Area_body_entered(body)](#--void-_on_area_body_enteredbody) |

### Property Descriptions
#### - [CombatVehicle] shooter
This is the attacking vehicle, that caused the instantiation of the money, or a replacement vehicle of the same player. Money moves towards the shooter.

#### - [CombatVehicle] spawner
This is the vehicle, that created this instance of money. Spawners cannot collect their own money.

#### - int reward
This is the score increase for collecting this Node.

#### - Node deletion_manager
This is the DeletionManager of the current track.

#### - float speed_divisor
Default: 20.0<br>
This number determines the movement speed of the money. A higher number means slower movement.

### Method Descriptions
#### - void _ready()
This method sets this Spatial as toplevel. Then, it sets the [spawner](#--bool-resources_loaded).

#### - void _process(_delta)
This method checks, if the shooter has a replacement. If true, the replacement becomes the shooter. Then it checks, if the [speed_divisor](#--float-speed_divisor) is below 0.15. (This would mean, that the movement speed is very fast.) If true, it moves the money into the [shooter](#--combatvehicle-shooter). Next, it moves the money towards the [shooter](#--combatvehicle-shooter). After that, it reduces the [speed_divisor](#--float-speed_divisor) by 1%.

#### - void _on_Area_body_entered(body)
This method checks if the body is the [spawner](#--combatvehicle-spawner). If false, it [rewards] the body, disables itself and queues itself for deletion by the [deletion_manager](#--node-deletion_manager). (The body should always be a [CombatVehicle], because of this Area's collision_mask.)
