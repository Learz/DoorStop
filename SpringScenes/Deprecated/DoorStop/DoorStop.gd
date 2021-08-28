extends Spatial

var pull_origin = Vector2(0,0)
var pull_current = Vector2(0,0)
var pull_strength = 0.0
var pull_direction = 0.0
var spring = get_child(0)
var spring_top = spring.get_child(0)
var pull_max = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Action")
	$AnimationPlayer.stop()
	pull_max = get_tree().root.get_viewport().size.y/2.4
	pass # Replace with function body.

func _physics_process(_delta):
	if(pull_strength >= 0.0):
		$AnimationPlayer.seek(pull_strength, true)
		spring.rotation = Vector3(0,-pull_direction-1.5708,0)
	else:
		$AnimationPlayer.seek(-pull_strength, true)
		spring.rotation = Vector3(0,-pull_direction-1.5708,0)+Vector3(0,3.14159,0)
		
#	spring_top.translation = Vector3(0,25*pull_strength,lerp(-33, -13.6, pull_strength))
#	spring_top.rotation = Vector3(lerp(-1.5708, 0 ,pull_strength),0,0)
	pass

