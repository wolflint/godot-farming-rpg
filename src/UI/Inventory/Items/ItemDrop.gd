extends KinematicBody2D

const ACCELERATION = 200
const MAX_SPEED = 200
var velocity = Vector2.ZERO

var player = null
var being_picked_up = false

export(String) var item_id = "tree_branch"
export(int) var item_quantity = 1  

func _ready():
	item_id = "tree_branch"
	$AnimationPlayer.play("FLOAT")

func _physics_process(delta):
	if being_picked_up == false:
		velocity = Vector2.ZERO
		return
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(self)
			if being_picked_up:
				queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)
		

func pick_up_item(body):
	player = body
	being_picked_up = true
