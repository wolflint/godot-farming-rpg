extends TileMap

onready var Player = get_node("Player")

func _process(delta):
	if Player.last_direction != Vector2.ZERO:
		request_tool_hit_location(Player, Player.last_direction)

func change_tile(cell, clicked_tile):
	# Check if the clicked tile is a dirt tile
	if cell == 0:
		# Set tile to a tilled tile
		set_cellv(clicked_tile, 12)
		print("Changed cell ", clicked_tile)
	elif cell != -1:
		print("Clicked on cell ", self.tile_set.tile_get_name(cell))

func request_tool_hit_location(player, direction):
	var player_cell = world_to_map(player.global_position)
	print("Player cell: " + str(player_cell))
	var tool_hit_target_cell = player_cell + direction
	print("Tool Hit Target Cell: " + str(tool_hit_target_cell))
	player.ToolHitIndicator.global_position = map_to_world(tool_hit_target_cell, true)

func get_player_tilemap_position(player):
	return world_to_map(player.position)

func check_players_click_range(player_tilepos, clicked_tile):
	# Check if the clicked tile is within the player's 9 tile reach radius
	if clicked_tile.x in range(player_tilepos.x - 1, player_tilepos.x + 2) and clicked_tile.y in range(player_tilepos.y - 1, player_tilepos.y + 2):
		return true
	return false
