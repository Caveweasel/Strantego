extends "res://Entities/AllyForager.gd"


func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerAlly.png") #Assigns sprite's texture
	self.texture = null
	
	#$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 25
	strength = 5
	species = "Formica fusca"
	efficiency = 0.5
	canattack = true
	hasspacebarability = true
	animationplayer = load("res://Entities/Animations/FormicaAnimations/AntmationsHDfuscaForager.tscn")
	satnest = load("res://Entities/Ants/Formica/FfuscaAllySatelliteNest.tscn")
	tilescale = 1
	isforager = true
	value = 45


func antimation():
	animation = "FormicaForagerIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
