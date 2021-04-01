extends Area2D
signal explode

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	get_parent().remove_child(self)
	queue_free()
	


func _on_Node2D_body_entered(body):
	if body.get('entity_type')=='player':
		emit_signal("explode",body)









