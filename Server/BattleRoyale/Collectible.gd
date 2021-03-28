extends Area2D
export var gun = 1
var entity_type = 'collectible'


func pack():
	return {
		'gun':gun,
		'x':position.x,
		'y':position.y,
		'id':get_instance_id()
	}


func _on_Node2D_body_entered(body):
	if body.get('entity_type')=='player':
		body.gun = gun
		body.gunbar = 100
		get_parent().remove_child(self)
		queue_free()
