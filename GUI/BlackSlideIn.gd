extends ColorRect


func slide_in():
	visible = true
	var movementtween = $Tween
	movementtween.interpolate_property(self, "rect_position",
	self.rect_position - Vector2(1920,0), self.rect_position, 0.5,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	movementtween.start()


