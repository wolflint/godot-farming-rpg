extends Node

const NUM_INVENTORY_SLOTS = 20

var inventory = {
	0: ["iron_sword", 1], # --> slot_index: [item_path, item_quantity]
	1: ["iron_sword", 1],
}

func add_item(item_id, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_id:
			# TODO: Check if slot is full
			inventory[item][1] += item_quantity
			return
	
	# Item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_id, item_quantity]
			return
