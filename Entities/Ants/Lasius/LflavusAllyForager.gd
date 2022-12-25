extends "res://Entities/AllyForager.gd"


func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerAlly.png") #Assigns sprite's texture
	self.texture = null
	
	#$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 15
	strength = 5
	species = "Lasius flavus"
	efficiency = 0.4
	canattack = true
	hasspacebarability = true
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDflavusForager.tscn")
	satnest = load("res://Entities/Ants/Lasius/LflavusAllySatelliteNest.tscn")
	tilescale = 1
	isforager = true
	value = 40
	harvestableresources = ["grass", "root"]


func antimation():
	animation = "LasiusForagerIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
