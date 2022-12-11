extends "res://Entities/AllyGyne.gd"


func _ready():
#	self.texture = load("res://Sprites/Entities/GyneAlly.png")
#	$Highlight.texture = load("res://Sprites/Entities/GyneHighlight.png") #Assigns highlights's texture
	self.texture = null
	$Highlight.texture = null
	
	forager = load("res://Entities/Ants/Formica/FfuscaAllyForager.tscn")
	foragercost = 15
	foragerincubationtime = 2
	troop = load("res://Entities/Ants/Formica/FfuscaAllyTroop.tscn")
	troopcost = 30
	troopincubationtime = 3
	health = 80
	#occupiedtile = arena.arenalength
	
	shadow = get_node("AntmationsHD/Shadow")
	species = "Formica fusca"
	
	animationplayer = load("res://Entities/Animations/FormicaAnimations/AntmationsHDFormicaGyne.tscn")
	antimation()
	tilescale = 2


func antimation():
	animation = "FormicaGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
