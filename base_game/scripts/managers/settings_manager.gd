extends Node


var resolution: int = 1
var msaa: int = Viewport.MSAA_DISABLED
var reflections: int = 0
var mirror_rate_reduced: bool = true
var transform_interpolation: bool = true
var view_distance: float = 1000.0
var rear_view_distance: float = 200.0
var field_of_view: float = 75.0
var shadow_casters: int = 3
var shadow_distance: float = 125.0
var max_texture_size: int = 4096
var max_rigid_bodies: int = 100

var split_screen_divisor: int = 1
