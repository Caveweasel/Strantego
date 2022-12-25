extends Node2D

func start_animation(e):
	
	get_child(get_child_count()-1).get_node("AntimationPlayer").start_anim(e.redstripes, e.animation)
