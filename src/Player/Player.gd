extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

enum {
	IDLE,
	WALK,
	RUN
}

var state = IDLE
var velocity = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	#match state:
	#	MOVE:
	move_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	move_animation(input_vector)
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		#state = IDLE
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()

func move_animation(direction):
	
	if direction != Vector2.ZERO:
		if direction.x > 0:
			$AnimationPlayer.play("WALK_RIGHT")
		elif direction.x < 0:
			$AnimationPlayer.play("WALK_LEFT")
		elif direction.y > 0:
			$AnimationPlayer.play("WALK_DOWN")
		elif direction.y < 0:
			$AnimationPlayer.play("WALK_UP")
	else:
		$AnimationPlayer.play("IDLE")

func move():
	velocity = move_and_slide(velocity)
		
