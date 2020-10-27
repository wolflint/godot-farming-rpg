extends Node

const MAX_INVENTORY_SLOTS = 20

var inventory = {
	0: ["iron_sword", 1], # --> slot_index: [item_path, item_quantity]
	1: ["tree_branch", 98],
}

func add_item(item_id, item_quantity):
	var available_slot = get_available_slot(item_id, item_quantity)
	if available_slot == -1:
		# TODO: Can't pick up the item, put the item in non pickupable state until a different body enters it's collision shape
		return
	if not inventory.has(available_slot):
		inventory[available_slot] = [item_id, item_quantity]
		return
	inventory[available_slot][1] += item_quantity
	return


func move_item(slot_id, new_slot_id):
	var slot_contents = inventory[slot_id]
	inventory.erase(slot_id)
	inventory[new_slot_id] = slot_contents

func get_available_slot(item_id, item_quantity):
	var first_empty_slot = null
	var stack_size = ItemData.item_data[item_id]["StackSize"]
	for slot in range(MAX_INVENTORY_SLOTS):
		if !inventory.has(slot) && first_empty_slot == null:
			first_empty_slot = slot
		elif inventory.has(slot):
			var total_item_quantity = inventory[slot][1] + item_quantity
			if inventory[slot][0] == item_id and total_item_quantity <= stack_size:
				return slot
	if first_empty_slot != null:
		return first_empty_slot
	return -1 # Return -1, which means that the inventory is full
