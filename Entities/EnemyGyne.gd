extends "res://Entities/AntcestorGyne.gd"
#Enemy variables
var AItype = "hyper aggressive"


func _ready():
	self.texture = load("res://Sprites/Entities/GyneEnemy.png")
	$Highlight.color1 = Color(1,0.15,0.15,1)
	$Highlight.color2 = Color(1,0.25,0.25,1)
	$Highlight.texture = load("res://Sprites/Entities/GyneHighlight.png") #Assigns highlights's texture
	$Highlight.color_update()
	isAI = true
	#scale.x = -1
	forager = load("res://Entities/EnemyForager.tscn")
	foragerincubationtime = 2
	troop = load("res://Entities/EnemyTroop.tscn")
	troopincubationtime = 3
	occupiedtile = arena.arenalength*2-1


func do():
	selected = true
	if producing == "null":
		AI()


func AI(): #Fully random AI chooses has a 50/50 chance to choose either option
	randomize()
	$WaitTimer.start()
	yield($WaitTimer, "timeout")
#	var r = randi() % 2
#	if r == 0:
#		producing = "forager"
#		eggtimer += 1
#		$EggTimer.setup(foragerincubationtime)
#	else:
	producing = "troop"
	eggtimer += 1
	$EggTimer.setup(troopincubationtime)
	
	moved = true
	get_tree().call_group("Arena", "arena_update")


