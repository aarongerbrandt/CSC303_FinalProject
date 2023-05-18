extends Control

var is_paused = false setget set_is_paused

func set_is_paused(value: bool):
#	print("is paused called: %s" % value)
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if is_paused else Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		self.is_paused = !is_paused

func _on_ResumeButton_pressed():
	set_is_paused(false)

func _on_ExitButton_pressed():
	get_tree().quit(0)
