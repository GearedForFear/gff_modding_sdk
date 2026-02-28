class_name ProjectileValues
extends Resource


enum ResouceTypes {AMMO, LEVEL, HEAT}
enum ProjectileTypes {BULLET, SNIPER_BULLET, CHAINSAW, MISSILE, GRENADE}
enum MovementTypes {STRAIGHT, ARC, STATIC_TARGET, DYNAMIC_TARGET, REMOTE}

export var damage: float = 2.0
export var reward: int = 1
export var burn: float = 0.2

export(ProjectileTypes) var projectile_type: int = ProjectileTypes.BULLET
export(MovementTypes) var movement_type: int = MovementTypes.STRAIGHT
