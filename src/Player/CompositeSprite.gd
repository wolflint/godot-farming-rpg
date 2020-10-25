extends Node2D

onready var Body = $SkinSprite
onready var Top = $TopSprite
onready var Bottom = $BottomSprite

export(Texture) var BodySprite = load("res://Player/skin/male_sprite_model.png")
export(Texture) var TopSprite = load("res://Player/tops/male_sprite_top.png")
export(Texture) var BottomSprite = load("res://Player/bottoms/male_sprite_bottoms.png")

func _ready():
	Body.texture = BodySprite
	Top.texture = TopSprite
	Bottom.texture = BottomSprite
	
	for child in get_children():
		if child.name != "AnimationPlayer":
			child.vframes = 4
			child.hframes = 8
