extends Control

func _ready():
	if OS.get_name() == "HTML5":
		$ColorRect/ExitButton.visible = false

func _on_ResumeButton_pressed():
	print("Resume!")
	visible = false
	get_tree().paused = false


func _on_ExitButton_pressed():
	print("Exit!")
	get_tree().quit(0)


func _on_ResumeButton_button_down():
	print("Resume!")
	visible = false
	get_tree().paused = false


func _on_ExitButton_button_down():
	print("Exit!")
	get_tree().quit(0)
