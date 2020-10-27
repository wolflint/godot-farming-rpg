extends Node2D

const SlotClass = preload("res://UI/Inventory/Slot.gd")
onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
		inv_slot.slot_id = inv_slot
		print(inv_slot.slot_id)
	initialise_inventory()

func initialise_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialise_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item: # Place holding item to slot
					slot.putIntoSlot(holding_item)
					holding_item = null
				else: 
					# If the items are different, swap them
					if holding_item.item_id != slot.item.item_id:
						var temp_item = slot.item
						slot.pickFromSlot()
						temp_item.global_position = event.global_position
						slot.putIntoSlot(holding_item)
						holding_item = temp_item
					# If the items are the same, try to merge them
					else:
						var stack_size = int(ItemData.item_data[slot.item.item_id]["StackSize"])
						var able_to_add = stack_size - slot.item.item_quantity
						if able_to_add >= holding_item.item_quantity:
							slot.item.add_item_quantity(holding_item.item_quantity)
							holding_item.queue_free()
							holding_item = null
						else:
							slot.item.add_item_quantity(able_to_add)
							holding_item.remove_item_quantity(able_to_add)
			elif slot.item:
				holding_item = slot.item
				slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()

func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
