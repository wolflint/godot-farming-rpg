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

func _on_player_idling(player):
	# TODO: fix the tool hit indicator. Diagonal input vectors can mess it up
	visible = true
	AnimPlayer.play("IN_RANGE")
	var player_position = Level.world_to_map(player.global_position)
	global_position = Level.map_to_world(player_position + player.last_input_direction)

func update_indicator(player_global_position):
	visible = true
	var player_level_position = Level.world_to_map(player_global_position)
	global_position = Level.map_to_world(player_level_position)
