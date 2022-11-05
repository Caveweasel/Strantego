extends "res://Entities/AllyGyne.gd"


func _ready():
#	self.texture = load("res://Sprites/Entities/GyneAlly.png")
#	$Highlight.texture = load("res://Sprites/Entities/GyneHighlight.png") #Assigns highlights's texture
	self.texture = null
	$Highlight.texture = null
	
	forager = load("res://Entities/Ants/Lasius/LnigerAllyForager.tscn")
	foragercost = 10
	foragerincubationtime = 2
	troop = load("res://Entities/Ants/Lasius/LnigerAllyTroop.tscn")
	troopcost = 20
	troopincubationtime = 3
	#occupiedtile = arena.arenalength
	
	shadow = get_node("AntmationsHD/Shadow")
	species = "Lasius niger"
	
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDLasiusGyne.tscn")
	antimation()
	tilescale = 2


func antimation():
	animation = "LasiusGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
