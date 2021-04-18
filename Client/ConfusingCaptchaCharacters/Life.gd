extends Node2D

func _ready():
	setLife(1)

func setLife(life):
	get_node("heart").frame = life;
