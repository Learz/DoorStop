extends Node

var fsm: StateMachine
onready var ds = get_node("../../DoorStop")
var pc = null
var po = null

func enter():
	print(ds.pull_origin)
	pc = ds.pull_current
	po = ds.pull_origin
	pass

func exit(next_state):
	fsm.change_to(next_state)

# Optional handler functions for game loop events
func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	return delta

func unhandled_input(event):
	if Input.is_action_just_released("Touch"):
		exit("Released")
	elif event is InputEventMouseMotion:
		pc = event.position
		ds.pull_strength = clamp(po.distance_to(pc)/ds.pull_max,0,1)
		ds.pull_direction = po.angle_to_point(pc)
#		get_node("../../Line2D").set_point_position(0,po)
#		get_node("../../Line2D").set_point_position(1,pc)
	return event

func unhandled_key_input(event):
	return event

