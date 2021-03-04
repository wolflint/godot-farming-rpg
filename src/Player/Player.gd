extends KinematicBody2D

onready var CurrentLevel = get_tree().get_root().get_node("World").get_node("Level")
onready var ToolHitIndicator = get_parent().get_node("ToolHitIndicatorSprite")
onready var PlayerLevelPosIndicator = get_parent().get_node("PlayerLevelPosIndicator")

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
var last_input_direction = Vector2.DOWN
var controller_connected = null
signal player_idling(player)

# Inventory and items
onready var pickup_zone = $ItemPickupZone

func _ready():
	AnimTree.active = true
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	connect("player_idling", ToolHitIndicator, "_on_player_idling")
	pickup_zone.Player = self

func _physics_process(delta):
	var input_vector = get_input_vector()
	match state:
		IDLE:
			animationState.travel("IDLE")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if input_vector != Vector2.ZERO:
				state = MOVE
		MOVE:
			PlayerLevelPosIndicator.update_indicator(global_position)
			ToolHitIndicator.visible = false
			move_state(delta, input_vector)
	velocity = move_and_slide(velocity)

func _unhandled_input(event):
	if state == IDLE:
		var player_localpos = CurrentLevel.get_object_local_position(self)
		var player_tilepos = CurrentLevel.world_to_map(player_localpos)
		var mouse_hover_pos = CurrentLevel.get_local_mouse_position()
		var hovered_tile = CurrentLevel.world_to_map(mouse_hover_pos)
		
		if event is InputEventMouseMotion:
			update_tool_indicator_after_mouse_movement(hovered_tile, player_tilepos)
		
		# If mouse is clicked within the player's range, till the soil
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if CurrentLevel.check_players_hit_range(player_tilepos, hovered_tile):
				CurrentLevel.change_tile(hovered_tile)
	
	else:
		Input.set_custom_mouse_cursor(cursorArrow)

func _input(_event):
	# TODO: fix the tool hit indicator. Diagonal input vectors can mess it up
	if state == IDLE:
		if Input.is_action_just_pressed("hit"):
			var player_localpos = CurrentLevel.get_object_local_position(self)
			var player_tilepos = CurrentLevel.world_to_map(player_localpos)
			print($CompositeSprite/AnimationPlayer.get("current_animation"))
			CurrentLevel.change_tile(player_tilepos + last_input_direction)

func update_tool_indicator_after_mouse_movement(hovered_tile, player_tilepos):
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

func move_state(delta, input_vector):
	if input_vector != Vector2.ZERO:
		# Set AnimTree params
		AnimTree.set("parameters/IDLE/blend_position", input_vector)
		AnimTree.set("parameters/WALK/blend_position", input_vector)
		animationState.travel("WALK")
		last_input_direction = input_vector.round()
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		emit_signal("player_idling", self)
		state = IDLE

func get_input_vector():
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return input_vector.normalized()

func _on_joy_connection_changed(device_id, connected):
	if connected:
		print(Input.get_joy_name(device_id) + " connected.")
		controller_connected = true
	else:
		print("Game controller disconnected.")
		controller_connected = false
	
