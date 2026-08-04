extends Mod_Base

var _bow_offset_x = 0
var _bow_offset_y = 0
var _bow_offset_z = 0.1
var _violin_offset_x = 0
var _violin_offset_y = -0.3
var _violin_offset_z = 0
var _violin_scale = 0.35
var _bow_scale = 0.5

var rhand_transform = Transform3D()
var head_transform = Transform3D()
var rhand_position = Vector3()
var head_position = Vector3()
var lhand_position = Vector3()

#func get_bone_transform(bone_name) -> Transform3D:
	#var skeleton = get_skeleton()
	#if skeleton:
		#var bone_index = skeleton.find_bone(bone_name)
		#if bone_index != -1:
			#return skeleton.get_bone_pose(bone_index)
	#return Transform3D()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: set position of violin relative to model bones,
	# 	set orientation according to hand position
	$Violin.transform.origin.x = head_position.x + _violin_offset_x
	$Violin.transform.origin.y = head_position.y + _violin_offset_y
	$Violin.transform.origin.z = head_position.z + _violin_offset_z
	
	$ViolinBow.transform.origin.x = rhand_position.x + _bow_offset_x
	$ViolinBow.transform.origin.y = rhand_position.y + _bow_offset_y
	$ViolinBow.transform.origin.z = rhand_position.z + _bow_offset_z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var tracker_data : Dictionary = get_global_mod_data("trackers")
	#print(tracker_data.get("hand_right"))
	if (tracker_data.get("hand_right")):
		rhand_position = tracker_data.get("hand_right").get("transform").origin
	if (tracker_data.get("hand_left")):
		lhand_position = tracker_data.get("hand_left").get("transform").origin
	if (tracker_data.get("head")):
		head_position = tracker_data.get("head").get("transform").origin
	
	#print(rhand_transform)
	# print(get_bone_transform("RightHand"))
	
	# TODO: constrain position and orientation of bow relative to contact point
	
	# set violin position relative to head
	$Violin.global_transform.origin.x = head_position.x + _violin_offset_x
	$Violin.global_transform.origin.y = head_position.y + _violin_offset_y
	$Violin.global_transform.origin.z = head_position.z + _violin_offset_z
	# TODO: make head offset, hand offset, and orientation all configurable.
	$Violin.global_transform.basis = $Violin.global_transform.looking_at(lhand_position).rotated_local(Vector3.UP, PI/2).basis * _violin_scale
	var contact_point = $Violin.find_child("ContactPoint")
	var contact_point_position = contact_point.global_position
	#print(contact_point_position)

	# TODO: set bow position relative to hand tracker wrist landmark
	$ViolinBow.global_transform.origin = rhand_position + Vector3(_bow_offset_x,_bow_offset_y, _bow_offset_z)
	# Align violin bow along its length (-X direction vector) to the vector between hand and contact point
	$ViolinBow.global_transform = $ViolinBow.global_transform.looking_at(contact_point_position)
	$ViolinBow.scale = Vector3(_bow_scale,_bow_scale,_bow_scale)
	#$ViolinBow.transform.basis = _bow_scale * $ViolinBow.transform.basis
	#print(contact_point.global_position)
	
