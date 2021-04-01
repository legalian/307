extends KinematicBody2D

var speed = 3500

var velocity
var owner_id


func _ready():
	velocity = Vector2(0, -speed).rotated(rotation)

func _physics_process(delta):
	# Somehow get direction from RacingCar.gd
	var collided = move_and_collide(velocity * delta)
	
	if collided:
		if (collided.collider.name.begins_with("Player")):
			if collided.collider.id == owner_id:
				return
			collided.collider.interrupt()
			print("collided with player!")
		else:
			print("collided with not a player!")
		queue_free() # Delete self
	

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'name':name
	}
