extends "res://Entities/AllyGyne.gd"


func _ready():
#	self.texture = load("res://Sprites/Entities/GyneAlly.png")
#	$Highlight.texture = load("res://Sprites/Entities/GyneHighlight.png") #Assigns highlights's texture
	self.texture = null
	$Highlight.texture = null
	
	forager = load("res://Entities/Ants/Lasius/LflavusAllyForager.tscn")
	foragercost = 10
	foragerincubationtime = 2
	troop = load("res://Entities/Ants/Lasius/LflavusAllyTroop.tscn")
	troopcost = 25
	troopincubationtime = 3
	#occupiedtile = arena.arenalength
	
	shadow = get_node("AntmationsHD/Shadow")
	species = "Lasius flavus"
	
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDflavusGyne.tscn")
	antimation()
	tilescale = 2


func antimation():
	animation = "LasiusGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
