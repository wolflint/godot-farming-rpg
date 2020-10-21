extends KinematicBody2D

var item_id

const ACCELERATION = 200
const MAX_SPEED = 200
var velocity = Vector2.ZERO

var player = null
var being_picked_up = false

func _ready():
	item_id = "tree_branch"

func _physics_process(delta):
	if being_picked_up == false:
		return
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_id, 1)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)
		

func pick_up_item(body):
	player = body
	being_picked_up = true
