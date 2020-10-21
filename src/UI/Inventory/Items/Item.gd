extends Node2D

onready var ItemTexture = $ItemTexture
onready var Quantity = $QuantityLabel

var item_id
var item_quantity

func _ready():
	
	if randi() % 2 == 0:
		item_id = "tree_branch"
	else:
		item_id = "iron_sword"
	
	ItemTexture.texture = load("res://UI/Inventory/Items/" + item_id + ".png")
	var stack_size = int(ItemData.item_data[item_id]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		Quantity.visible = false
	else:
		Quantity.visible = true
		Quantity.text = str(item_quantity)

func set_item(id, quantity):
	item_id = id
	item_quantity = quantity
	ItemTexture.texture = load("res://UI/Inventory/Items/" + item_id + ".png")
	
	var stack_size = int(ItemData.item_data[item_id]["StackSize"])
	if stack_size == 1:
		Quantity.visible = false
	else:
		Quantity.visible = true
		Quantity.text = str(item_quantity)

func add_item_quantity(amount):
	item_quantity += amount
	Quantity.text = str(item_quantity)

func remove_item_quantity(amount):
	item_quantity -= amount
	Quantity.text = str(item_quantity)

