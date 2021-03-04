extends Sprite

onready var Level = get_tree().get_root().get_node("World").get_node("Level")

func update_indicator(player_global_position):
	var player_level_position = Level.world_to_map(player_global_position)
	global_position = Level.map_to_world(player_level_position)
