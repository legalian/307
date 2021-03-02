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

func rotclamp(amt):
	if amt>PI: return amt-2*PI
	if amt<-PI: return amt+2*PI
	return amt

func glob_rot(node):
	#return (leftbody.get_global_transform_with_canvas().affine_inverse()*node.get_global_transform_with_canvas()).get_rotation()
	return rotclamp(node.global_rotation-leftbody.global_rotation)
	
func glob_pos(node):
	#print(node.global_position)
	#print(node.position)
	#print(node.get_parent().global_transform.affine_inverse().xform(node.global_position))
	#print(leftbody.global_transform.xform_inv(node.global_position))
	return leftbody.global_transform.affine_inverse().xform(node.global_position)
	
func set_glob_rot(node,rot):
	#print(leftbody.rotation)
	node.global_rotation = rot+leftbody.global_rotation

func _process(delta):
	var target = get_node(targetpath)
	var ik_node = get_node(ikpath)

	transforms = []
	rotation_offsets = []
	_calc_ik222(self, ik_node, target, glob_rot(get_parent()))
	_apply_ik222(self, ik_node)


func _calc_ik222(node, ik_node, target_node, parrot, index = 0):
	var length = 0
	transforms.append(null)
	rotation_offsets.append(null)
	if node.get_child_count() > 0 and node != ik_node:
		var target = glob_pos(node.get_child(0))
		rotation_offsets[index] = node.get_child(0).position.angle()
		length = (target - glob_pos(node)).length()
		_calc_ik222(node.get_child(0), ik_node, target_node, glob_rot(node), index + 1)
	if node == ik_node:
		var rot = 0
		var pos = glob_pos(target_node)
		transforms[index] = Transform2D(rot, pos)
	else:
		#print(body)
		#print(get_node(body))
		#print(get_node(body).isFacingLeft())
		var rotmin = deg2rad(node.rot_min_left if leftbody.isFacingLeft() else node.rot_min_right)
		var rotmax = deg2rad(node.rot_max_left if leftbody.isFacingLeft() else node.rot_max_right)
		#print(rotmin,",",rotmax)
		var adj = transforms[index+1].get_origin() - glob_pos(node)
		#adj.y/=.44
		var rot = adj.angle()
		
		parrot = parrot + rotation_offsets[index]
		rot = rot-parrot
		#if (rot<)
		while rotmin+rotmax>rot+PI:
			rotmin-=2*PI
			rotmax-=2*PI
		while rotmin+rotmax<rot-PI:
			rotmin+=2*PI
			rotmax+=2*PI
		
		
		rot = max(rotmin,min(rotmax,rot))+parrot
		
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
		set_glob_rot(node,rotation_to_apply)
		
		node.rotation = min(deg2rad(rotmax),max(deg2rad(rotmin),rotclamp(node.rotation)))






