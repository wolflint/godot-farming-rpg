extends TileMap

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mousePos = self.get_local_mouse_position()
		var loc = world_to_map(mousePos)
		var cell = get_cellv(loc)
		
		if cell == 0:
			set_cellv(loc, 12)
		elif cell != -1:
			print("Clicked on cell ", self.tile_set.tile_get_name(cell))
