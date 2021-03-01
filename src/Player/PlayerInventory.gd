extends Node

const MAX_INVENTORY_SLOTS = 20

var inventory = {
	# --> slot_index: [item_path, item_quantity]
	5: ["iron_sword", 1],
	6: ["tree_branch", 98]
}

func add_item(item_drop):
	var item_id = item_drop.item_id
	var item_quantity = item_drop.item_quantity
	var available_slot = get_available_slot(item_id, item_quantity)
	if available_slot == -1:
		item_drop.being_picked_up = false
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
	
	# Check if there is a partial stack of this item in the inventory
	# If so, return its slot number
	for slot in inventory:
		if inventory[slot][0] != item_id || (inventory[slot][1] + item_quantity) > stack_size:
			continue
		return slot
	
	# If this item isn't in the invotory, return the first free slot number 
	for slot in range(MAX_INVENTORY_SLOTS):
		if !inventory.has(slot):
			return slot
	
	# If the inventory is full, return -1
	return -1
