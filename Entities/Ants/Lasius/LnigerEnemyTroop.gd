extends "res://Entities/EnemyTroop.gd"

func constructor():
#	self.texture = load("res://Sprites/Entities/TroopEnemy.png") #Assigns sprite's texture
	self.texture = null
#	$Highlight.color1 = Color(1,0.15,0.15,1)
#	$Highlight.color2 = Color(1,0.25,0.25,1)
#	$Highlight.texture = load("res://Sprites/Entities/TroopHighlight.png") #Assigns highlights's texture
	health = 30
	strength = 15
	species = "Lasius niger"
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDnigerTroop.tscn")
	tilescale = 1
	value = 50

func antimation():
	animation = "LasiusTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
