extends "res://Entities/AllyTroop.gd"


func constructor():
	#self.texture = load("res://Sprites/Entities/TroopAlly.png") #Assigns sprite's texture
	#self.texture = null
	#$Highlight.texture = load("res://Sprites/Entities/TroopHighlight.png") #Assigns highlights's texture
	health = 40
	strength = 20
	species = "Formica fusca"
	animationplayer = load("res://Entities/Animations/FormicaAnimations/AntmationsHDfuscaTroop.tscn")
	value = 60
	tilescale = 1


func antimation():
	animation = "FormicaTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
