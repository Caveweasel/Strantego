extends "res://Entities/Mover.gd"


func constructor():
	#self.texture = load("res://Sprites/Entities/TroopAlly.png") #Assigns sprite's texture
	#self.texture = null
	#$Highlight.texture = load("res://Sprites/Entities/TroopHighlight.png") #Assigns highlights's texture
	health = 30
	strength = 20
	animationplayer = load("res://Entities/Animations/AntimationsHD.tscn")
	tilescale = 1

#func _ready():
##	animationplayer = $AntmationsHD/AntimationPlayer.start_anim(true, "LasiusTroopIdle")
#	antimation()


func antimation():
	animation = "LasiusTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
