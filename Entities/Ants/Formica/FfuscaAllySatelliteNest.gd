extends "res://Entities/AncestorSatelliteNest.gd"


func _ready():
	troop = load("res://Entities/Ants/Formica/FfuscaAllyTroop.tscn")
	troopcost = 30
	troopincubationtime = 3
	health = 80
	foragerefficiency = 0.5
	#occupiedtile = arena.arenalength
	
	shadow = get_node("AntmationsHD/Shadow")
	species = "Formica fusca"
	
	animationplayer = load("res://Entities/Animations/FormicaAnimations/AntmationsHDFormicaGyne.tscn")
	antimation()
	tilescale = 2


func antimation():
	animation = "FormicaGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(null, animation)
