extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var anim = null
	
# Called when the node enters the scene tree for the first time.
func _ready():
	anim = get_node("Animation")
	hide()
	
func fire():
	frame = (randi()%10)*4
	show()
	anim.play("FiringAnim")

func nextFrame():
	frame+=1

func stop():
	anim.stop()
	hide()

func beginfire():
	show()
	anim.play("Continuous")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
