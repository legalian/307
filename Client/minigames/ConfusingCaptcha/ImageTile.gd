extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func correct():
	modulate = Color(0,1,0);

func wrong():
	modulate = Color(1,0,0)

func reset():
	modulate = Color(1,1,1);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
