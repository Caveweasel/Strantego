extends Sprite

func move_in(won):
	if not won:
		texture = load("res://Sprites/Level/AlphaLosePanel.png")
	
	var movementtween = $MoveTween
	movementtween.interpolate_property(self, "position",
	position, Vector2(960,-403), 1,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	movementtween.start()


func _on_ContinueButton_pressed():
#	var blackscreen = load("res://GUI/BlackSlideIn.tscn").instance()
#	get_node("/root/BattleSceneTest").add_child(blackscreen)
#	blackscreen.get_child(0).rect_position = get_parent().get_parent().position - Vector2(960,540)
#	blackscreen.get_child(0).slide_in()
	$BlackScreenTimer.start()


func _on_BlackScreenTimer_timeout():
	get_tree().paused = false
	get_tree().change_scene("res://GUI/Overworld.tscn")
