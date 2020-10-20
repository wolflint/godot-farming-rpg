extends KinematicBody2D

# Cursor Sprites
var cursorArrow = load("res://Rand/cursor_arrow.png")
var cursorHoe = load("res://Rand/cursor_hoe.png")
onready var ToolHitIndicator = get_parent().get_node("ToolHitIndicatorSprite")

# Physics
export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

# Animation
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# States
enum {
	IDLE,
	MOVE,
}

# Input
var last_direction = Vector2.ZERO
var controller_connected = null

# Signals
signal entered_level(player)

# Get the current level.
onready var CurrentLevel = get_parent()
var state = MOVE
var velocity = Vector2.ZERO

func _ready():
	animationTree.active = true
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

func _physics_process(delta):
	match state:
		IDLE:
			pass
		MOVE:
			move_state(delta)

func _unhandled_input(event):
	var mouse_hover_pos = CurrentLevel.get_local_mouse_position()
	var hovered_tile = CurrentLevel.world_to_map(mouse_hover_pos)
	var player_tilepos = CurrentLevel.get_player_tilemap_position(self)
	
	# Toggle between Hoe/Arrow cursor when player hovers in/out of his range
	if event is InputEventMouseMotion:
		if CurrentLevel.check_players_hit_range(player_tilepos, hovered_tile):
			change_cursor(cursorHoe)
			ToolHitIndicator.visible = true
			ToolHitIndicator.AnimPlayer.play("IN_RANGE")
		elif CurrentLevel.check_players_hit_range(player_tilepos, hovered_tile, 2):
			change_cursor(cursorArrow)
			ToolHitIndicator.visible = true
			ToolHitIndicator.AnimPlayer.play("OUT_OF_RANGE")
		else:
			change_cursor(cursorArrow)
			ToolHitIndicator.visible = false
	
	# If mouse is clicked within the player's range, till the soil
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var cell = CurrentLevel.get_cellv(hovered_tile)
		if CurrentLevel.check_players_hit_range(player_tilepos, hovered_tile):
			CurrentLevel.change_tile(cell, hovered_tile)

func change_cursor(cursor):
	Input.set_custom_mouse_cursor(cursor)

func move_state(delta):
	# Set input vector
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		# Set animationTree params
		animationTree.set("parameters/IDLE/blend_position", input_vector)
		animationTree.set("parameters/WALK/blend_position", input_vector)
		animationState.travel("WALK")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("IDLE")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		var player_tilepos = CurrentLevel.get_player_tilemap_position(self)
		var tool_hit_location_tilepos = player_tilepos + input_vector
	move()

func update_tool_hit_location(input_vector):
	if not input_vector:
		return

func get_input_vector():
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	last_direction = input_vector
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
	
