
extends Sprite


var TargetNode
onready var StartOffset = self.transform.origin - TargetNode.transform.origin

func _process(delta):
	self.transform.origin = TargetNode.transform.origin + StartOffset
