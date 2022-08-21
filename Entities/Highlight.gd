extends Sprite

var color1 = Color(0.3,0.3,1,1)
var color2 = Color(0.4,0.4,1,1)
onready var tween = get_node("ColorTween")


func _ready():
	color_update()


func color_update():
	tween.interpolate_property(self, "self_modulate",
	color1, color2, 2,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()


func _on_ColorTween_tween_completed(_object, _key):
	if self_modulate == color1:
		tween.interpolate_property(self, "self_modulate",
		color1, color2, 2,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property(self, "self_modulate",
		color2, color1, 2,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
