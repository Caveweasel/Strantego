extends Camera2D

var overworldtop = -668
var overworldbottom = 668

func _ready():
	position.y = get_node("/root/Global").cameray


func _physics_process(_delta):
	if Input.is_action_pressed("ui_up"):
		if position.y > overworldtop:
			position.y -= 20
		else:
			position.y = overworldtop
	if Input.is_action_pressed("ui_down"):
		if position.y < overworldbottom:
			position.y += 20
		else:
			position.y = overworldbottom

