extends AnimatedSprite

func _ready():
	var shader = load("res://objects/car.shader")
	var mat = ShaderMaterial.new()
	mat.shader = shader
	material = mat

