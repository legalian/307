extends KinematicBody2D

var speed = 3500

var velocity
var owner_id

func _ready():
	velocity = Vector2(0, -speed).rotated(rotation)

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	var collided = move_and_collide(velocity * delta)
	
	if collided:
		if (collided.collider.name.begins_with("Player")):
			if collided.collider.id == owner_id:
				return
			collided.collider.interrupt()
			print("collided with player!")
		elif (collided.collider.name.begins_with("Projectile")):
			get_parent().remove_child(collided.collider)
			print("collided with another projectile; remove both")
		elif (collided.collider.name.begins_with("Powerup")):
			print("collided with powerup box! collision bits set incorrectly")
		else:
			print("did not collide with a player or projectile")
		
		queue_free() # Delete self
	

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'name':name
	}
