extends CanvasLayer

func _input(event):
	if event.is_action_pressed("inventory"):
		Input.set_custom_mouse_cursor(load("res://Rand/cursor_arrow.png"))
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialise_inventory()

func _ready():
	pass
