extends Node2D


func _ready():
	
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://Rand/Iron Sword.png")
	else:
		$TextureRect.texture = load("res://Rand/Tree Branch.png")
