extends "res://Entities/AllyForager.gd"


func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerAlly.png") #Assigns sprite's texture
	self.texture = null
	
	#$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 20
	strength = 5
	species = "Lasius niger"
	efficiency = 0.5
	canattack = true
	hasspacebarability = true
	animationplayer = load("res://Entities/Animations/AntimationsHD.tscn")
	tilescale = 1


func antimation():
	animation = "LasiusTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
