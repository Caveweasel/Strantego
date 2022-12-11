extends Sprite

export var starty = -202
export var tweeny = 540

func move_in():
	get_tree().paused = true
	var movementtween = $MoveTween
	movementtween.interpolate_property(self, "position",
	position, Vector2(960,tweeny), 0.75,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	movementtween.start()

func move_out():
	get_tree().paused = false
	var movementtween = $MoveTween
	movementtween.interpolate_property(self, "position",
	position, Vector2(960,starty), 0.75,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	movementtween.start()



func _on_YesButton_pressed():
	var blackscreen = load("res://GUI/BlackSlideIn.tscn").instance()
	get_node("/root/BattleSceneTest").add_child(blackscreen)
	blackscreen.get_child(0).rect_position = get_parent().get_parent().position - Vector2(960,540)
	blackscreen.get_child(0).slide_in()
	$BlackScreenTimer.start()


func _on_NoButton_pressed():
	move_out()


func _on_BlackScreenTimer_timeout():
	get_tree().paused = false
	get_tree().change_scene("res://GUI/Overworld.tscn")
