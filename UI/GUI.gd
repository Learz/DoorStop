extends Control

var menu_open = false

func _physics_process(_delta):
	$FPS.text = str(Engine.get_frames_per_second())
	$DebugInfo.text = "Debug : " + str(Global.debugInfo)

func _on_InfoButton_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		$BlindBG.visible = !$BlindBG.visible
