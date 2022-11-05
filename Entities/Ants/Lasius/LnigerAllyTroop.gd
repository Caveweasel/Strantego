extends "res://Entities/AllyTroop.gd"


func constructor():
	#self.texture = load("res://Sprites/Entities/TroopAlly.png") #Assigns sprite's texture
	#self.texture = null
	#$Highlight.texture = load("res://Sprites/Entities/TroopHighlight.png") #Assigns highlights's texture
	health = 30
	strength = 20
	species = "Lasius niger"
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDnigerTroop.tscn")
	
	tilescale = 1


func antimation():
	animation = "LasiusTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
