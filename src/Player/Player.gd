extends KinematicBody2D

onready var ToolHitIndicator = get_parent().get_node("ToolHitIndicatorSprite")
onready var CurrentLevel = get_tree().get_root().get_node("World").get_node("Level")

# Animation
onready var AnimTree = $AnimationTree
onready var animationState = AnimTree.get("parameters/playback")

# Cursor Sprites
var cursorArrow = load("res://Rand/cursor_arrow.png")
var cursorHoe = load("res://Rand/cursor_hoe.png")

# Physics
export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500
var velocity = Vector2.ZERO

# States
enum {
	IDLE,
	MOVE,
}
var state = MOVE

# Input
var controller_connected = null

# Inventory and items
onready var pickup_zone = $ItemPickupZone

func _ready():
	AnimTree.active = true
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	pickup_zone.player = self

func _physics_process(delta):
	var input_vector = get_input_vector()
	match state:
		IDLE:
			if input_vector != Vector2.ZERO:
				state = MOVE
		MOVE:
			move_state(delta, input_vector)

func _unhandled_input(event):
	var mouse_hover_pos = CurrentLevel.get_local_mouse_position()
	var hovered_tile = CurrentLevel.world_to_map(mouse_hover_pos)
	var player_tilepos = CurrentLevel.get_player_tilemap_position(self)
	
	if event is InputEventMouseMotion:
		change_cursor(hovered_tile, player_tilepos)
	
	# If mouse is clicked within the player's range, till the soil
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var cell = CurrentLevel.get_cellv(hovered_tile)
		if CurrentLevel.check_players_hit_range(player_tilepos, hovered_tile):
			CurrentLevel.change_tile(cell, hovered_tile)

func change_cursor(hovered_tile, player_tilepos):
	if CurrentLevel.check_players_hit_range(player_tilepos, hovered_tile):
		Input.set_custom_mouse_cursor(cursorHoe)
		ToolHitIndicator.visible = true
		ToolHitIndicator.AnimPlayer.play("IN_RANGE")
	elif CurrentLevel.check_players_hit_range(player_tilepos, hovered_tile, 2):
		Input.set_custom_mouse_cursor(cursorArrow)
		ToolHitIndicator.visible = true
		ToolHitIndicator.AnimPlayer.play("OUT_OF_RANGE")
	else:
		Input.set_custom_mouse_cursor(cursorArrow)
		ToolHitIndicator.visible = false

func move_state(delta, input_vector):
	if input_vector != Vector2.ZERO:
		# Set AnimTree params
		AnimTree.set("parameters/IDLE/blend_position", input_vector)
		AnimTree.set("parameters/WALK/blend_position", input_vector)
		animationState.travel("WALK")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("IDLE")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		var player_tilepos = CurrentLevel.get_player_tilemap_position(self)
	move()

func get_input_vector():
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return input_vector.normalized()

func move():
	velocity = move_and_slide(velocity)

func _on_joy_connection_changed(device_id, connected):
	if connected:
		print(Input.get_joy_name(device_id) + " connected.")
		controller_connected = true
	else:
		print("Game controller disconnected.")
		controller_connected = false
	
