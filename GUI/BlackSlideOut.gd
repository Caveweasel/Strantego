extends ColorRect


func slide_out():
	visible = true
	var movementtween = $Tween
	movementtween.interpolate_property(self, "rect_position",
	self.rect_position, self.rect_position + Vector2(1920,0), 0.5,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	movementtween.start()
	$DeathTimer.start()


func _on_DeathTimer_timeout():
	queue_free()
