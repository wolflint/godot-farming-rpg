extends TileMap

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mousePos = self.get_local_mouse_position()
		var cell_pos = world_to_map(mousePos)
		var cell = get_cellv(cell_pos)
		_change_tile(cell, cell_pos)

func _change_tile(cell, cell_pos):
	# Check if the clicked tile is a dirt tile
	if cell == 0:
		# Set tile to a tilled tile
		set_cellv(cell_pos, 12)
		print("Changed cell ", cell_pos)
	elif cell != -1:
		print("Clicked on cell ", self.tile_set.tile_get_name(cell))

func _check_player_range():
	pass
# Changed cell (0, 0)
# Changed cell (1, 0)
# Changed cell (1, 1)
# Changed cell (0, 1)
# Changed cell (-1, 1)
# Changed cell (-1, 0)
# Changed cell (-1, -1)
# Changed cell (0, -1)
# Changed cell (1, -1)
