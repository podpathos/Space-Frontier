tool
extends Node2D

# class member variables go here, for example:
export var rotation_rate = 0.15
export var orbit_rate = 0.00002
export var star_radius_factor = 1.0
export var luminosity = 1.00 # 1 is the luminosity of the Sun

var hz_inner = 0.9 #dummy, in AU
var hz_outer = 1.1

var rot = 0
var orbit_rot = 0

onready var sprite = $"Sprite"
#onready var planets = $"planet_holder"
var planets = null

# for minimap
export var zoom_scale = 12
export var custom_orrery_scale = 0
export var custom_map_scale = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if has_node("planet_holder"):
		planets = get_node("planet_holder")
		for c in get_node("planet_holder").get_children():
			if c != null and c.is_in_group("planets"):
				c.setup()
				# moons
				for m in c.get_node("orbit_holder").get_children():
					m.setup()
	
	var hzs = calculate_hz(luminosity)
	hz_inner = hzs[0]
	hz_outer = hzs[1]

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

	if not Engine.is_editor_hint():
		# rotate the star sprite
		rot += rotation_rate * delta
		sprite.set_rotation(rot)
		
		if planets != null:
			orbit_rot += orbit_rate * delta
			planets.set_rotation(orbit_rot)


# http://www.solstation.com/habitable.htm
# Kasting et al, 1993
func calculate_hz(lum):
	# "normalized solar flux factor" values for a G-type star
	var inner = 1 * pow(lum / 1.41, 0.5)
	var outer = 1 * pow(lum / 0.36, 0.5)
	
	return [inner, outer]

# based on arc functions that I seem to love :P	
func make_circle(center, segments, radius):
	var points_arc = PoolVector2Array()
	var angle_from = 0
	var angle_to = 360

	for i in range(segments+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/segments - 90
		var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
		points_arc.push_back( point )
	
	return points_arc	

func draw_empty_circle(circle):
	draw_polyline(circle, Color(0,1,0), 2.0)
