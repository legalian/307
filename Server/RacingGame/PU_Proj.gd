extends KinematicBody2D

var speed = 1500

var velocity

func _ready():
	set_process(true)

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	var collided = move_and_collide(velocity * delta)
	
	if collided:
		print("collided with something")
		get_parent().remove_child(self)
		print("Collided with: " + collided.collider.name)
		if (collided.collider.name.begins_with("Player")):
			collided.collider.interrupt()
			print("collided with player!")
		elif (collided.collider.name.begins_with("Projectile")):
			get_parent().remove_child(collided.collider)
			print("collided with another projectile; remove both")
		else:
			print("did not collide with a player or projectile")
	

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'name':name
	}
