extends TileMap

onready var Player = get_node("YSort").get_node("Player")

func change_tile(cell, hit_cell):
	# Check if the clicked tile is a dirt tile
	if cell == 0:
		# Set tile to a tilled tile
		set_cellv(hit_cell, 12)
#	elif cell != -1:

func get_player_tilemap_position(player):
	return world_to_map(player.position)

func check_players_hit_range(player_cell, hit_cell, radius = 1):
	if hit_cell.x in range(player_cell.x - radius, player_cell.x + (radius + 1)) and hit_cell.y in range(player_cell.y - radius, player_cell.y + (radius + 1)):
		return true
	return false
