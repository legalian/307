extends KinematicBody2D

var owner_id;
var velocity


func _physics_process(_delta):
	velocity = Vector2(0,0)
	var collided = move_and_collide(velocity);
	if collided:
		if (collided.collider.name.begins_with("Player")):
			if collided.collider.id == owner_id:
				return
			collided.collider.stun(3, 400);
			print("trap collided with player!")
		else:
			print("trap collided with not a player!")
		queue_free() # Delete self
	
func pack():
	return {
		'x':position.x,
		'y':position.y,
		'name':name
	}