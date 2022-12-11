extends "res://Entities/EnemyForager.gd"

func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerEnemy.png") #Assigns sprite's texture
	self.texture = null
#	$Highlight.color1 = Color(1,0.15,0.15,1)
#	$Highlight.color2 = Color(1,0.25,0.25,1)
#	$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 20
	strength = 5
	species = "Lasius niger"
	efficiency = 0.4
	hasspacebarability = true
	isforager = true
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDLasiusForager.tscn")
	tilescale = 1
	value = 40

func antimation():
	animation = "LasiusForagerIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
