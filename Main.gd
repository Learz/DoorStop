extends Node

export(Array, PackedScene) var scenes

var title = "Game v0.1"
var glitchStrength = 0
var nextScene = preload("res://SpringScenes/DoorStopV2/Scene.tscn")
#var mainScene = preload("res://SpringScenes/DoorStopV2/Scene.tscn")
var isInMainScene = true
var glitch_safe_zone = 3

func _ready():
	pass

func _process(_delta):
	OS.set_window_title(title + " | fps: " + str(Engine.get_frames_per_second()))

func glitch():
	$Glitch.visible = true
	$Glitch/Timer.start()
	
	AudioServer.set_bus_effect_enabled(0,1,true)
	
#	glitchStrength += 0.01
	$Glitch.material.set_shader_param("shake_power", 0.05 + glitchStrength)
	$Glitch.material.set_shader_param("shake_color_rate", 0.01 + glitchStrength)
	
	
	nextScene = scenes[randi() % scenes.size()]
	$SubScene.add_child(nextScene.instance(), true)
	$SubScene.move_child($SubScene.get_child(1), 0)
	
	$SubScene.get_child(0).set_initial_state($SubScene.get_child(1).pull_strength, $SubScene.get_child(1).pull_direction)
	$SubScene.get_child(1).queue_free()
	$SubScene.get_child(0).is_current = true
	isInMainScene = !isInMainScene

func try_glitching():
	if !$Glitch/Timer.is_stopped():
		return false
	glitch_safe_zone = max(0, glitch_safe_zone-1)
	if(glitch_safe_zone + (randi() % 6) == 0):
		glitch()
		glitch_safe_zone = 3
		return true
	else:
		return false

func _on_Timer_timeout():
	$Glitch.visible = false
	AudioServer.set_bus_effect_enabled(0,1,false)
