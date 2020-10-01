extends TileMap


#func _process(delta):
#	if Input.is_mouse_button_pressed(1):
#		var mousepos = get_viewport().get_mouse_position()
#		print("Mouse Position: ", mousepos)
#		var tilepos = world_to_map(mousepos)
#		print("Tile Position: ", tilepos)
#
#		var cell = get_cellv(tilepos)
#		if cell != -1:
#			print(self.tile_set.tile_get_name(cell))
#		else:
#			set_cellv(tilepos, 1)

func _unhandled_input(event):
	if event.is_action_released("left_mouse_click"):
		var tilePos = world_to_map(event.global_position)
		var cell = get_cellv(tilePos)
		if cell != -1:
			print(self.tile_set.tile_get_name(cell))
		else:
			set_cellv(tilePos, 1)
