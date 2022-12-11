extends Sprite

export var sprite = "res://Sprites/GUI/StartingResourceUpgrade.png"
onready var pos1 = position
onready var pos2 = position-Vector2(0,24)
var tweentime = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = load(sprite)
	
	var floattween = $FloatTween
	floattween.interpolate_property(self, "position",
	pos1, pos2, tweentime,
	Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	floattween.start()


func _on_FloatTween_tween_all_completed():
	if position == pos1:
		var floattween = $FloatTween
		floattween.interpolate_property(self, "position",
		pos1, pos2, tweentime,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		floattween.start()
	else:
		var floattween = $FloatTween
		floattween.interpolate_property(self, "position",
		pos2, pos1, tweentime,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		floattween.start()
