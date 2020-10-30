extends Area2D

var items_in_range = {}
var player = null

func _ready():
	pass


func _on_ItemPickupZone_body_entered(body):
	items_in_range[body] = body
	body.pick_up_item(player)


func _on_ItemPickupZone_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)
