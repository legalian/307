tool
extends Bone2D

var rotation_offsets
var transforms
var leftbody

export(NodePath) var targetpath
export(NodePath) var ikpath
export(NodePath) var body

export(int) var rot_min_left
export(int) var rot_max_left
export(int) var rot_min_right
export(int) var rot_max_right

func _ready():
	set_process(true)
	leftbody = get_node(body)

func _process(delta):
	var target = get_node(targetpath)
	var ik_node = get_node(ikpath)

	transforms = []
	rotation_offsets = []
	_calc_ik222(self, ik_node, target, get_parent().global_rotation)
	_apply_ik222(self, ik_node)


func _calc_ik222(node, ik_node, target_node, parrot, index = 0):
	var length = 0
	transforms.append(null)
	rotation_offsets.append(null)
	if node.get_child_count() > 0 and node != ik_node:
		var target = node.get_child(0).global_position
		rotation_offsets[index] = node.get_child(0).position.angle()
		length = (target - node.global_position).length()
		_calc_ik222(node.get_child(0), ik_node, target_node, node.global_rotation, index + 1)
	if node == ik_node:
		var rot = 0
		var pos = target_node.global_position
		transforms[index] = Transform2D(rot, pos)
	else:
		#print(body)
		#print(get_node(body))
		#print(get_node(body).isFacingLeft())
		var rotmin = node.rot_min_left if leftbody.isFacingLeft() else node.rot_min_right
		var rotmax = node.rot_max_left if leftbody.isFacingLeft() else node.rot_max_right
		#print(rotmin,",",rotmax)
		var rot = (transforms[index+1].get_origin() - node.global_position).angle()
		parrot = parrot + rotation_offsets[index]
		
		rot = max(deg2rad(rotmin)+parrot,min(deg2rad(rotmax)+parrot,rot))
		
		var pos = (transforms[index+1].get_origin() - (Vector2.RIGHT * length).rotated(rot))
		transforms[index] = Transform2D(rot, pos)


func _apply_ik222(node, ik_node, index = 0):
	if node != ik_node:
		#print(body)
		#print(get_node(body))
		#print(get_node(body).isFacingLeft())
		var rotmin = node.rot_min_left if leftbody.isFacingLeft() else node.rot_min_right
		var rotmax = node.rot_max_left if leftbody.isFacingLeft() else node.rot_max_right
		#print(rotmin,",",rotmax)
		var rotation_to_apply = transforms[index].get_rotation() - rotation_offsets[index]

		_apply_ik222(node.get_child(0), ik_node, index + 1)
		node.global_rotation = rotation_to_apply
		node.rotation = min(deg2rad(rotmax),max(deg2rad(rotmin),node.rotation))






