extends "res://Entities/EnemyTroop.gd"

func constructor():
#	self.texture = load("res://Sprites/Entities/TroopEnemy.png") #Assigns sprite's texture
	self.texture = null
#	$Highlight.color1 = Color(1,0.15,0.15,1)
#	$Highlight.color2 = Color(1,0.25,0.25,1)
#	$Highlight.texture = load("res://Sprites/Entities/TroopHighlight.png") #Assigns highlights's texture
	health = 40
	strength = 20
	species = "Formica fusca"
	animationplayer = load("res://Entities/Animations/FormicaAnimations/AntmationsHDfuscaTroop.tscn")
	value = 60
	tilescale = 1

func antimation():
	animation = "FormicaTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
