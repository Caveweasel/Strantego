extends TileMap

#Global variables
onready var arena = get_node("/root/BattleSceneTest")
#TileMap variables
var currentcell = 0


func arena_ready():
	for y in arena.arenawidth:
		for x in arena.arenalength:
			randomize()
			set_cell(x, y, plains(x,y,true))
			#print(Vector2(x*128, y*128))
	set_cell(0, (arena.arenawidth-1)/2, plains(0,0,false))
	set_cell(arena.arenalength-1, (arena.arenawidth-1)/2, plains(0,0,false))

func plains(x,y,random): #If random is false it returns a dirt tile
	if random:
		var i = randf()
		
		if i < 0.7:
			return 3 #Dirt tile
		elif i < 0.8:
			return 0 #Grass tile
		elif i < 0.9:
			return 2 #Sprout tile
		elif y != 1 and x != 0 and x != arena.arenalength - 1:
			return 1 #Rock Tile
		else:
			return 3 #Dirt tile
	else:
		return 3 #Dirt tile
