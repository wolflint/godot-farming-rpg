extends KinematicBody2D

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

var state = MOVE
var velocity = Vector2.ZERO

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		IDLE:
			pass
		MOVE:
			move_state(delta)

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
	move()

#func set_idle_state(delta):
#	state = IDLE
#	animationState.travel("IDLE")
#	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	

func move():
	velocity = move_and_slide(velocity)
		
