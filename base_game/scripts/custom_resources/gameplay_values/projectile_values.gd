class_name ProjectileValues
extends Resource


enum ResouceTypes {AMMO, LEVEL, HEAT}
enum ProjectileTypes {BULLET, SNIPER_BULLET, CHAINSAW, MISSILE, GRENADE}
enum MovementTypes {STRAIGHT, ARC, STATIC_TARGET, DYNAMIC_TARGET, REMOTE}

export(float, 0.1, 100) var damage = 2.0
export(float, 0.1, 100) var burn = 0.2
export(int, 1, 1000) var reward = 1
export(int, 0, 600) var cooldown = 6 # in ticks (60 per second)

export(ProjectileTypes) var projectile_type: int = ProjectileTypes.BULLET
export(MovementTypes) var movement_type: int = MovementTypes.STRAIGHT
