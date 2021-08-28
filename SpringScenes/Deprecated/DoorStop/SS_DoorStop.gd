extends ViewportContainer


var initial_position = Vector3(0,0,0)
export var is_current = false setget _set_is_current

func _ready():
	pass

func _process(_delta):
#	if initial_position == Vector3(0,0,0):
#		initial_position = Input.get_gravity()
#	$Viewport/CameraAnchor.rotation.x = (initial_position.y - Input.get_gravity().y)/50*-1
#	$Viewport/CameraAnchor.rotation.z = (initial_position.x - Input.get_gravity().x)/50*-1
	pass

func _set_is_current(new_value):
	is_current = new_value
	if is_current:
		$Viewport/TwangSFX.bus = "Master"
		$Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	else:
		$Viewport/TwangSFX.bus = "Mute"
		$Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
		
