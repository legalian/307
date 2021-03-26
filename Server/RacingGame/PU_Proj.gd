extends KinematicBody2D

var speed = 1500

var velocity


func _ready():
	set_process(true)
	velocity = Vector2(speed, speed) #.rotated(r)

func _physics_process(delta):
	# Somehow get direction from RacingCar.gd
	var collided = move_and_collide(velocity * delta)
	
	if collided:
		print("collided with something")
		get_parent().remove_child(self)
		print("Collided with: " + collided.collider.name)
		if (collided.collider.name.begins_with("Player")):
			collided.collider.interrupt()
			print("collided with player!")
		else:
			print("collided with not a player!")
	

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'name':name
	}
