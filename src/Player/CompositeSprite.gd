extends Node2D

onready var Body = $Body
onready var Top = $Top
onready var Bottom = $Bottom

export(Texture) var BodyTexture = load("res://Player/skin/male_sprite_model.png")
export(Texture) var TopTexture = load("res://Player/tops/male_sprite_top.png")
export(Texture) var BottomTexture = load("res://Player/bottoms/male_sprite_bottoms.png")

func _ready():
	Body.texture = BodyTexture
	Top.texture = TopTexture
	Bottom.texture = BottomTexture
	
	for child in get_children():
		if child.name != "AnimationPlayer":
			child.vframes = 1
			child.hframes = 26
