tool
extends AnimatedSprite

func _ready():
	get_material().set_shader_param("frame", frame / float(frames.get_frame_count("default")))

func _on_Sprite_frame_changed():
	get_material().set_shader_param("frame", frame / float(frames.get_frame_count("default")))
