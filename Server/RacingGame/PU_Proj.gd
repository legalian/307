extends KinematicBody2D

#Layer 1 is the Car
#Layer 2 is the world objects
#Layer 3 is the powerup box
#Layer 4 currently has missile + trap

var speed = 3500

var velocity
var owner_id

func _ready():
	velocity = Vector2(0, -speed).rotated(rotation)

func _physics_process(delta):
	var min_dist = INF
	var nearest_player = null
	for player in get_parent().get_parent().ingame.values():
		if player.id != owner_id:
			var cur_dist = position.distance_to(player.position)
			if cur_dist < min_dist:
				min_dist = cur_dist
				nearest_player = player
				
	if nearest_player != null:
		print(rotation)
		var angle = position.angle_to_point(nearest_player.position) - PI
		rotation = lerp_angle(rotation, angle, 0.20)
	
	velocity = Vector2(speed, 0).rotated(rotation)
	var collided = move_and_collide(velocity * delta)
	
	if collided:
		if (collided.collider.name.begins_with("Player")):
			if collided.collider.id == owner_id:
				return
			get_parent().get_parent().notifystrike(owner_id,collided.collider.id)
			collided.collider.interrupt()
			print("collided with player!")
		elif (collided.collider.name.begins_with("Projectile")):
			get_parent().remove_child(collided.collider)
			print("collided with another projectile; remove both")
		elif (collided.collider.name.begins_with("Trap")):
			get_parent().remove_child(collided.collider)
			print("collided with a trap; remove both")
		elif (collided.collider.name.begins_with("Powerup")):
			print("collided with powerup box! collision bits set incorrectly")
		else:
			print("did not collide with a player or projectile")
		
		get_parent().remove_child(self)
		queue_free() # Delete self
	

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'name':name
	}
