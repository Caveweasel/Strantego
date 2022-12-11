extends "res://Entities/NonAnts/NonAntcestor.gd"


func constructor():
	isant = false
	self_modulate = Color(1,1,1,1)
	animationplayer = load("res://Entities/Animations/NonAntAnimations/AntmationsHDEarwig.tscn")
	tilescale = 2
	species = "Earwig"
	shadow = get_node("AntmationsHD/Shadow")
	health = 60
	strength = 25
	resourcegain = 25

func antimation():
	animation = "EarwigIdle"
	$AntmationsHD/AntimationPlayer.start_anim(null, animation)
