extends "res://Entities/NonAnts/NonAntcestor.gd"


func constructor():
	moveable = false
	isant = false
	self_modulate = Color(1,1,1,1)
	animationplayer = load("res://Entities/Animations/NonAntAnimations/AntmationsHDIsopod.tscn")
	tilescale = 2
	species = "Isopod"
	shadow = get_node("AntmationsHD/Shadow")
	health = 50
	strength = 0
	value = 10
	resourcegain = 40


func antimation():
	animation = "IsopodIdle"
	$AntmationsHD/AntimationPlayer.start_anim(null, animation)


func do():
	moved = true
	selected = false
	get_tree().call_group("Arena", "arena_update")

func AI():
	pass
