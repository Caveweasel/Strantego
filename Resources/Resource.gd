extends Sprite

#Global variables
onready var arena = get_node("/root/BattleSceneTest")
#Object variables
var occupiedtile = 1 #The tile this entity is occupying
var occupiedxtile = 0
var occupiedytile = 0
#Resource variables
var resources = 10


func arena_ready():
	occupiedtile = arena.tiles.find(position)
#	position = arena.tiles[occupiedtile]
	occupiedytile = ceil(float(occupiedtile / arena.arenalength)) #Finds out which Y tile this entity is occupying
	occupiedxtile = ceil(float(occupiedtile - occupiedytile * arena.arenalength)) #Finds out which X tile this entity is occupying

