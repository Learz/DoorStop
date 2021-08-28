extends ViewportContainer

export var is_current = false setget _set_is_current;

onready var doorstop = $Viewport/DoorstopV2
onready var doorstop_animation = $Viewport/DoorstopV2/AnimationPlayer
onready var twang_sfx = $Viewport/TwangSFX

var pull_origin = Vector2(0,0)
var pull_current = Vector2(0,0)
var pull_strength = 0.0
var spring_time = 0
var pull_direction = 0.0
var pull_max = null

enum STATE {IDLE, PULLING, RELEASED}
var state = STATE.IDLE

var time = 0
var freq = 90

# Called when the node enters the scene tree for the first time.
func _ready():
	doorstop_animation.play("ArmatureAction")
	doorstop_animation.seek(1,true)
	doorstop_animation.stop()
	pull_max = get_tree().root.get_viewport().size.y/2.4

func _unhandled_input(event):
	if Input.is_action_just_pressed("Touch"):
		pull_origin = event.position
		state = STATE.PULLING
	if Input.is_action_just_released("Touch"):
		state = STATE.RELEASED
		
		if is_visible_in_tree(): 
			get_tree().root.get_child(1).try_glitching()
		
		spring_time = pull_strength
		twang_sfx.pitch_scale = 1
		twang_sfx.volume_db = pull_strength*5
		twang_sfx.play()
	if Input.is_action_pressed("Touch"):
		pull_current = event.position

func _physics_process(delta):
	match state:
		STATE.IDLE:
			pass
		STATE.PULLING:
			time = 0
			pull_strength = clamp(pull_origin.distance_to(pull_current)/pull_max,0,1)
			pull_direction = pull_origin.angle_to_point(pull_current)
		STATE.RELEASED:
			time += 1
			var wobble = sin(time*delta*freq)
			if(spring_time >= 0.4):
				#initial_pull -= log(time)/600
				spring_time = (spring_time/1.01)
			elif spring_time >= 0:
				spring_time -= 0.005
			else:
				state = STATE.IDLE
			
			pull_strength = spring_time * wobble
			if wobble <= 0.9 and wobble >= -0.9 :
				twang_sfx.play(0.0)
			twang_sfx.pitch_scale = 0.5+(1-spring_time)*0.7
			twang_sfx.volume_db -= 0.2+(1-spring_time)*0.3
	
	if state != STATE.IDLE:
		doorstop_animation.seek(pull_strength+1, true)
		doorstop.rotation = Vector3(0,-pull_direction+1.5708,0)

func set_initial_state(l_pull_strength, l_pull_direction):
	time = 0
	pull_strength = l_pull_strength
	pull_direction = l_pull_direction
	
	spring_time = pull_strength
	twang_sfx.pitch_scale = 1
	twang_sfx.volume_db = pull_strength*5
	twang_sfx.play()
	
	state = STATE.RELEASED

func _set_is_current(new_value):
	is_current = new_value
	if is_current:
		$Viewport/TwangSFX.bus = "Master"
		$Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	else:
		$Viewport/TwangSFX.bus = "Mute"
		$Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
