extends Control

func _ready():
	$BlackSlideOut/BlackSlideOut.slide_out()


func _on_TextureButton_pressed():
	var blackscreen = load("res://GUI/BlackSlideIn.tscn").instance()
	add_child(blackscreen)
	blackscreen.get_child(0).rect_position = rect_position
	blackscreen.get_child(0).slide_in()
	$BlackScreenTimer.start()

func _on_BlackScreenTimer_timeout():
	get_tree().change_scene("res://GUI/Overworld.tscn")


func _on_CloseButton_pressed():
	get_tree().quit()
