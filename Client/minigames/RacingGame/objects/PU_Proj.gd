extends Node2D


func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
