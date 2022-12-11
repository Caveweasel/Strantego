extends "res://Entities/AncestorSatelliteNest.gd"


func _ready():
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
	$AntmationsHD/AntimationPlayer.start_anim(null, animation)
