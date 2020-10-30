extends Node

const MAX_INVENTORY_SLOTS = 20

var inventory = {
	0: ["iron_sword", 1], # --> slot_index: [item_path, item_quantity]
	1: ["tree_branch", 98],
	2: ["tree_branch", 99],
	3: ["tree_branch", 99],
	4: ["tree_branch", 99],
	5: ["tree_branch", 99],
	6: ["tree_branch", 99],
	7: ["tree_branch", 99],
	8: ["tree_branch", 99],
	9: ["tree_branch", 99],
	10: ["tree_branch", 99],
	11: ["tree_branch", 99],
	12: ["tree_branch", 99],
	13: ["tree_branch", 99],
	14: ["tree_branch", 99],
	15: ["tree_branch", 99],
	16: ["tree_branch", 99],
	17: ["tree_branch", 99],
	18: ["tree_branch", 99],
	19: ["tree_branch", 99],
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
