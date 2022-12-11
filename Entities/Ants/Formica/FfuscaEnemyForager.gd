extends "res://Entities/EnemyForager.gd"

func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerEnemy.png") #Assigns sprite's texture
	self.texture = null
#	$Highlight.color1 = Color(1,0.15,0.15,1)
#	$Highlight.color2 = Color(1,0.25,0.25,1)
#	$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 25
	strength = 5
	species = "Formica fusca"
	efficiency = 0.5
	hasspacebarability = true
	isforager = true
	animationplayer = load("res://Entities/Animations/FormicaAnimations/AntmationsHDfuscaForager.tscn")
	tilescale = 1
	value = 45

func antimation():
	animation = "FormicaForagerIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
