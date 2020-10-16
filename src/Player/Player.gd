extends KinematicBody2D

# Cursor Sprites
var cursorArrow = load("res://Rand/cursor_arrow.png")
var cursorHoe = load("res://Rand/cursor_hoe.png")

# Physics
export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

# Input
var last_input = Vector2.ZERO

# Animation
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# States
enum {
	IDLE,
	MOVE,
}

# Signals
signal entered_level(player)

# Get the current level.
onready var current_level = get_parent()
onready var toolHitLocation = $ToolHitLocationSprite
var state = MOVE
var velocity = Vector2.ZERO

func _ready():
#	connect("entered_level", current_level, "on_player_entered_level")
#	if current_level != null:
#		emit_signal("entered_level", self)
	animationTree.active = true

func _physics_process(delta):
	match state:
		IDLE:
			pass
		MOVE:
			move_state(delta)

func _unhandled_input(event):
	var mouse_hover_pos = current_level.get_local_mouse_position()
	var hovered_tile = current_level.world_to_map(mouse_hover_pos)
	var player_tilepos = current_level.get_player_tilemap_position(self)
	
	# Toggle between Hoe/Arrow cursor when player hovers in/out of his range
	
	if event is InputEventMouseMotion:
		if current_level.check_players_click_range(player_tilepos, hovered_tile):
			change_cursor(cursorHoe)
			toolHitLocation.global_position = current_level.map_to_world(hovered_tile, true)
			print("Mouse local position: " + str(get_local_mouse_position()))
			print("ToolHitLocation global position: " + str(toolHitLocation.global_position))
			toolHitLocation.visible = true
		else:
			change_cursor(cursorArrow)
			toolHitLocation.visible = false
	
	# If mouse is clicked within the player's range, till the soil
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var cell = current_level.get_cellv(hovered_tile)
		if current_level.check_players_click_range(player_tilepos, hovered_tile):
			current_level.change_tile(cell, hovered_tile)


func change_cursor(cursor):
	Input.set_custom_mouse_cursor(cursor)

func move_state(delta):
	# Set input vector
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# Set animationTree params
		animationTree.set("parameters/IDLE/blend_position", input_vector)
		animationTree.set("parameters/WALK/blend_position", input_vector)
		animationState.travel("WALK")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			
	else:
		animationState.travel("IDLE")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		var player_tilepos = current_level.get_player_tilemap_position(self)
		var tool_hit_location_tilepos = player_tilepos + input_vector
		toolHitLocation.position = current_level.map_to_world(tool_hit_location_tilepos)
		toolHitLocation.visible = true
	last_input = input_vector
	move()

#func set_idle_state(delta):
#	state = IDLE
#	animationState.travel("IDLE")
#	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	

func move():
	velocity = move_and_slide(velocity)
		
