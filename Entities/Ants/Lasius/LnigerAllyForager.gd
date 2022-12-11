extends "res://Entities/AllyForager.gd"


func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerAlly.png") #Assigns sprite's texture
	self.texture = null
	
	#$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 20
	strength = 5
	species = "Lasius niger"
	efficiency = 0.4
	canattack = true
	hasspacebarability = true
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDLasiusForager.tscn")
	tilescale = 1
	isforager = true
	value = 40


func antimation():
	animation = "LasiusForagerIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
