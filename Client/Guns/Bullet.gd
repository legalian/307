extends KinematicBody2D

var id
var body
var trail
export(float) var height
var speed = 1500
var velocity = Vector2()
var trailLen = 0
var trailLenMax = 300


func pack():
	return {
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation
	}

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	velocity = Vector2(-speed, 0).rotated(rotation)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	body = get_node("Body")
	trail = get_node("Body/Trail")
	velocity = Vector2(-speed, 0).rotated(rotation)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var gt = get_global_transform_with_canvas()
	gt.origin = Vector2(0,0)
	var trot = gt.get_rotation()#.scaled(Vector2(1,.44))
	body.transform = gt.affine_inverse()*Transform2D(trot,Vector2(0,-height))
	trail.scale.x = (trailLen/5)*(.44)/(1+(.44-1)*cos(trot)*cos(trot))
	trail.scale.y = 1-trailLen/trailLenMax

func _physics_process(delta):
	position = position + velocity*delta
	#var collision = move_and_collide(velocity * delta)
	#if collision:
	#	#velocity = velocity.bounce(collision.normal)
	#	#rotation = velocity.angle()+PI
	#	trailLen = 0
	#	#if collision.collider.has_method("hit"):
	#	#	collision.collider.hit()
	#else:
	#	trailLen = min(trailLen+(velocity * delta).length(),trailLenMax)
	

#func _on_VisibilityNotifier2D_screen_exited():
#	queue_free()





