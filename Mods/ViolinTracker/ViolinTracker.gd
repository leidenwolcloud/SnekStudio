extends Mod_Base

var _bow_offset_x = 0.05
var _bow_offset_y = -0.02
var _bow_offset_z = 0
var _violin_rest_offset_x = 0
var _violin_rest_offset_y = -0.08
var _violin_rest_offset_z = -0.4
var _violin_offset_x = 0
var _violin_offset_y = -0.31
var _violin_offset_z = 0
var _violin_scale = 0.034
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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var tracker_data : Dictionary = get_global_mod_data("trackers")
	var lhand_active : bool
	var rhand_active : bool
	#print(tracker_data.get("hand_right"))
	var rhand_data = tracker_data.get("hand_right")
	var rhand_transform = Transform3D()
	var rhand_orientation = Vector3()
	if (rhand_data):
		rhand_position = rhand_data.get("transform").origin
		rhand_orientation = rhand_data.get("transform").basis.get_euler()
		rhand_transform = rhand_data.get("transform")
		rhand_active = rhand_data.get("active")
		
	var lhand_data = tracker_data.get("hand_left")
	if (lhand_data):
		lhand_position = lhand_data.get("transform").origin
		lhand_active = lhand_data.get("active")
		
	if (tracker_data.get("head")):
		head_position = tracker_data.get("head").get("transform").origin
	
	#print(rhand_transform)
	# print(get_bone_transform("RightHand"))
	
	# TODO: constrain position and orientation of bow relative to contact point
	
	# set violin position relative to head
	
	
	# TODO: make head offset, hand offset, and orientation all configurable.
	if (lhand_active):
		$Violin.global_transform.basis = $Violin.global_transform.looking_at(lhand_position).rotated_local(Vector3.UP, PI/2).basis * _violin_scale
		$Violin.global_transform.origin.x = head_position.x + _violin_offset_x 
		$Violin.global_transform.origin.y = head_position.y + _violin_offset_y
		$Violin.global_transform.origin.z = head_position.z + _violin_offset_z
	else:
		$Violin.rotation = Vector3(0,-PI/2,0)
		$Violin.global_transform.origin = lhand_position + Vector3(_violin_rest_offset_x, _violin_rest_offset_y, _violin_rest_offset_z)
		
	var contact_point = $Violin.find_child("ContactPoint")
	var contact_point_position = contact_point.global_position
	#print(contact_point_position)

	# TODO: set bow position relative to hand tracker wrist landmark
	
	$ViolinBow.global_transform.origin = rhand_position + Vector3(_bow_offset_x,_bow_offset_y, _bow_offset_z) # FIXME: offset locally relative to the hand
	# Align violin bow along its length (-X direction vector) to the vector betwe$ViolinBow.global_transformen hand and contact point
	if (rhand_active):
		if (lhand_active):
			$ViolinBow.global_transform = $ViolinBow.global_transform.looking_at(contact_point_position, Vector3(0,1,0), true)
		else:
			$ViolinBow.global_transform.basis = rhand_transform.basis
	else:
		$ViolinBow.rotation = Vector3(0,0,0)
	$ViolinBow.scale = Vector3(_bow_scale,_bow_scale,_bow_scale)
	#$ViolinBow.transform.basis = _bow_scale * $ViolinBow.transform.basis
	#print(contact_point.global_position)
	
