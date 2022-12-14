extends Node2D

#var number = -10


func start(num, pos):
#	number = -num
	if num <= 0:
		$Number.text = str(num)
	else:
		$Number.text = "+" + str(num)
	position = pos


func change_type(color,image):
	$Number.add_color_override("font_color", color)
	$Category.texture = image


func _on_HalfTimer_timeout():
	$HalfTimer.stop()
	modulate = Color(1,1,1,1)
	var postween = $PosTween
	postween.interpolate_property(self, "position",
	position, position - Vector2(0,64), 0.75,
	Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	postween.start()
	$LifeTimer.start()


func _on_LifeTimer_timeout():
	if modulate != Color(1,1,1,0):
		var vistween = $VisTween
		vistween.interpolate_property(self, "modulate",
		modulate, Color(1,1,1,0), 0.25,
		Tween.TRANS_CUBIC, Tween.EASE_IN)
		vistween.start()
		$LifeTimer.start()
	else:
		queue_free()


