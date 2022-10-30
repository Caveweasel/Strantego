extends Sprite

func move_in(won):
	if not won:
		texture = load("res://Sprites/Level/AlphaLosePanel.png")
	
	var movementtween = $MoveTween
	movementtween.interpolate_property(self, "position",
	position, Vector2(960,-403), 1,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	movementtween.start()
