extends TextureButton


func _on_LevelButton_pressed():
	get_parent().enter_level(name)
