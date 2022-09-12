extends Label

func _process(_delta):
	if get_viewport().get_mouse_position().x <= 60 and get_viewport().get_mouse_position().y >= 824:
		visible = true
		rect_position.x = get_parent().get_global_mouse_position().x
		rect_position.y = get_parent().get_global_mouse_position().y - 20
	else:
		visible = false
	
