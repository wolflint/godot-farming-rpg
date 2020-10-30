extends Sprite

onready var mouse_position = get_global_mouse_position()
onready var AnimPlayer = $AnimationPlayer
onready var Level = get_tree().get_root().get_node("World").get_node("Level")

func _ready():
	visible = false


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		visible = true
		mouse_position = get_global_mouse_position()
		var hovered_cell = Level.world_to_map(mouse_position)
		global_position = Level.map_to_world(hovered_cell)
