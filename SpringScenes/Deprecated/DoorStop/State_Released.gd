extends Node

var fsm: StateMachine
onready var ds = get_node("../../DoorStop")
onready var twang_sfx = get_node("../../TwangSFX")
onready var local_root = get_node("../../..")
var time = 0
var initial_pull = 0
var freq = 90

func enter():
	if local_root.is_current: 
		get_tree().root.get_child(0).try_glitching()
	time = 1
	initial_pull = ds.pull_strength
	if initial_pull <= 0.005:
		exit("Idle")
		return
	twang_sfx.pitch_scale = 1
	twang_sfx.volume_db = initial_pull*5
	twang_sfx.play()
#	Input.vibrate_handheld(800*initial_pull)

func exit(next_state):
	fsm.change_to(next_state)

# Optional handler functions for game loop events
func process(delta):
	
	return delta

func physics_process(delta):
	time += 1
	var wobble = sin(time*delta*freq)
	if(initial_pull >= 0.4):
		#initial_pull -= log(time)/600
		initial_pull = (initial_pull/1.01)
	elif initial_pull >= 0:
		initial_pull -= 0.005
	else:
		exit("Idle")
		
	ds.pull_strength = initial_pull * wobble
	if wobble <= 0.9 and wobble >= -0.9 :
		twang_sfx.play(0.0)
	twang_sfx.pitch_scale = 0.5+(1-initial_pull)*0.7
	twang_sfx.volume_db -= 0.2+(1-initial_pull)*0.3
	return delta

func unhandled_input(event):
	if Input.is_action_just_pressed("Touch"):
		ds.pull_origin = event.position
		print(ds.pull_origin)
		fsm.change_to("Pulling")
	return event

func unhandled_key_input(event):
	return event


