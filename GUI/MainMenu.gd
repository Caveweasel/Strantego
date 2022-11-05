extends Control


func _on_TextureButton_pressed():
	get_tree().change_scene("res://GUI/Overworld.tscn")


func _on_CloseButton_pressed():
	get_tree().quit()
