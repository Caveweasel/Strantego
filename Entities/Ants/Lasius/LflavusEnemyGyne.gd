extends "res://Entities/EnemyGyne.gd"


func _ready():
#	self.texture = load("res://Sprites/Entities/GyneEnemy.png")
#	$Highlight.color1 = Color(1,0.15,0.15,1)
#	$Highlight.color2 = Color(1,0.25,0.25,1)
#	$Highlight.texture = load("res://Sprites/Entities/GyneHighlight.png") #Assigns highlights's texture
#	$Highlight.color_update()
	self.texture = null
	$Highlight.texture = null
	
	isAI = true
	#scale.x = -1
	forager = load("res://Entities/Ants/Lasius/LflavusEnemyForager.tscn")
	foragercost = 10
	foragerincubationtime = 2
	foragerefficiency = 0.4
	troop = load("res://Entities/Ants/Lasius/LflavusEnemyTroop.tscn")
	troopcost = 25
	troopincubationtime = 3
	#occupiedtile = arena.arenalength*2-1
	
	species = "Lasius flavus"
	shadow = get_node("AntmationsHD/Shadow")
	
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDflavusGyne.tscn")
	antimation()
	tilescale = 2


func antimation():
	animation = "LasiusGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
