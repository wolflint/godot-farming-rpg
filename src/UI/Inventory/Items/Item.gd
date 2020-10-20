extends Node2D

onready var ItemTexture = $ItemTexture
onready var Quantity = $QuantityLabel

var item_path
var item_quantity

func _ready():
	
	if randi() % 2 == 0:
		item_path = "tree_branch"
	else:
		item_path = "iron_sword"
	
	ItemTexture.texture = load("res://UI/Inventory/Items/" + item_path + ".png")
	var stack_size = int(ItemData.item_data[item_path]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
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
