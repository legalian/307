extends AnimatedSprite

#var VehicleStyles = ["Sedan","Van","Truck","Race","Taxi","Future"]

func _ready():
	var shader = load("res://objects/car.shader")
	var mat = ShaderMaterial.new()
	mat.shader = shader
	material = mat
	

