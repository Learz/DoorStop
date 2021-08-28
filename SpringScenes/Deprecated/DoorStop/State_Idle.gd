extends Node

var fsm: StateMachine
onready var ds = get_node("../../DoorStop")
onready var twang_sfx = get_node("../../TwangSFX")


func enter():
	ds.pull_strength = 0
	twang_sfx.stop()

func exit():
	# Go back to the last state
	fsm.back()

func unhandled_input(event):
	if Input.is_action_just_pressed("Touch"):
		ds.pull_origin = event.position
		print(ds.pull_origin)
		fsm.change_to("Pulling")
	return event
