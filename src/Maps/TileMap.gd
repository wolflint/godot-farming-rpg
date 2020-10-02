extends TileMap

var cursor_arrow = load("res://Rand/cursor_arrow.png")
var cursor_hoe = load("res://Rand/cursor_hoe.png")

func _unhandled_input(event):
	var mousePos = self.get_local_mouse_position()
	var mouseTilePos = world_to_map(mousePos)
	
	if event is InputEventMouseMotion:
		if _mouse_in_player_range(mouseTilePos):
			_change_cursor(cursor_hoe)
		else:
			_change_cursor(cursor_arrow)
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		
		var cell = get_cellv(mouseTilePos)
		
		if _mouse_in_player_range(mouseTilePos):
			_change_tile(cell, mouseTilePos)

func _change_cursor(cursor):
	Input.set_custom_mouse_cursor(cursor)

func _change_tile(cell, mouseTilePos):
	# Check if the clicked tile is a dirt tile
	if cell == 0:
		# Set tile to a tilled tile
		set_cellv(mouseTilePos, 12)
		print("Changed cell ", mouseTilePos)
	elif cell != -1:
		print("Clicked on cell ", self.tile_set.tile_get_name(cell))

func _mouse_in_player_range(mouseTilePos):
	var playerTile = world_to_map($Player.position)
	# Check if the clicked tile is within the player's 9 tile reach radius
	if mouseTilePos.x in range(playerTile.x - 1, playerTile.x + 2) and mouseTilePos.y in range(playerTile.y - 1, playerTile.y + 2):
		return true
	return false
