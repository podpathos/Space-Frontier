extends "boid.gd"

# class member variables go here, for example:

# bullets
export(PackedScene) var bullet
onready var bullet_container = $"bullet_container"
#onready var bullet = preload("res://bullet.tscn")
onready var gun_timer = $"gun_timer"

var targetted = false
var tractor = false
signal AI_targeted


func _ready():

	# Called every time the node is added to the scene.
	# Initialization here
	pass

# using this because we don't need physics
func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

	# redraw 
	update()
	
	if tractor and not get_parent().get_parent().get_parent().is_in_group("player"):
		#print("Parent is " + get_parent().get_parent().get_parent().get_name())
		target = tractor.get_node("dock").get_global_position()
	
		rel_pos = get_global_transform().xform_inv(target)
		#print("Rel pos: " + str(rel_pos) + " abs y: " + str(abs(rel_pos.y)))
		
		# steering behavior
		var steer = get_steering_seek(target, 80)
		# normal case
		vel += steer
	
		# movement happens!
		#acc += vel * -friction
		#vel += acc *delta
		pos += vel * delta
		set_position(pos)
		
		# snap once close enough
		var dist = get_global_position().distance_to(tractor.get_node("dock").get_global_position())
		if dist < 20:
			# reparent
			get_parent().get_parent().remove_child(get_parent())
			tractor.add_child(get_parent())
			# set better z so that we don't overlap parent ship
			get_parent().set_z_index(-1)
			
			# all local positions relative to the immediate parent
			get_parent().set_position(tractor.get_node("dock").get_position()+Vector2(0,20))
			set_position(Vector2(0,0))
			print("Adding colony as tractoring ship's child")
			# switch off tractor
			tractor = null
		
	#pass

func shoot():
	gun_timer.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rotation(), $"muzzle".get_global_position())


# AI
# atan2(0,-1) returns 180 degrees in 3.0, we want 0
# this counts in radians
func fix_atan(x,y):
	var ret = 0
	var at = atan2(x,y)

	if at > 0:
		ret = at - PI
	else:
		ret= at + PI

	return ret


# draw a red rectangle around the target
func _draw():
	if targetted:
		var rect = Rect2(Vector2(-26, -26),	Vector2(91*0.6, 91*0.6))

		draw_rect(rect, Color(1,0,0), false)
		
	if tractor:
		var tr = get_child(0)
		var rc_h = tr.get_texture().get_height() * tr.get_scale().x
		var rc_w = tr.get_texture().get_height() * tr.get_scale().y
		var rect = Rect2(Vector2(-rc_w/2, -rc_h/2), Vector2(rc_w, rc_h))
		
		draw_rect(rect, Color(1,1,0), false)

# click to target functionality
func _on_Area2D_input_event(viewport, event, shape_idx):
	# any mouse click
	if event is InputEventMouseButton:
		targetted = true
		emit_signal("AI_targeted")
		# redraw
		update()
