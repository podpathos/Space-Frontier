extends Node2D

var entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(_area):
	if not entered:
		var system = get_tree().get_nodes_in_group("main")[0].curr_system
		print("Wormhole entered in system: ", system)
		entered = true
		
		# change the system
		if system == "Sol":
			get_tree().get_nodes_in_group("main")[0].change_system()
		if system == "proxima":
			get_tree().get_nodes_in_group("main")[0].change_system("alphacen")
		
		
