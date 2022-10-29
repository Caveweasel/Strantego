extends "res://Entities/AntcestorGyne.gd"
#Enemy variables
#var AItype = "hyper aggressive"
var foragerefficiency = 1


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
	forager = load("res://Entities/EnemyForager.tscn")
	foragercost = 10
	foragerincubationtime = 2
	foragerefficiency = 0.5
	troop = load("res://Entities/EnemyTroop.tscn")
	troopcost = 20
	troopincubationtime = 3
	occupiedtile = arena.arenalength*2-1
	
	shadow = get_node("AntmationsHD/Shadow")
	
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDLasiusGyne.tscn")
	antimation()
	tilescale = 2


func do():
	if not dead:
		selected = true
		thinking = true
		if producing == "null":
			AI()
		thinking = false


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
	moved = true
	selected = false
	thinking = false
	
	var ownallyforagercount = 0
	var ownallytroopcount = 0
	if not ownallies.resources < foragercost and not ownallies.resources < troopcost:
		for i in ownallies.get_child_count():
			if not ownallies.get_child(i) == self:
				if ownallies.get_child(i).isforager:
					ownallyforagercount += 1
				else:
					ownallytroopcount += 1
		
		if ownallyforagercount == 0 and ownallytroopcount == 0 and ownallies.resources >= foragercost:
			producing = "forager"
			eggtimer += 1
			$EggTimer.setup(foragerincubationtime)
			
			ownallies.resources -= foragercost
		
#		elif ownallyforagercount == 1 and ownallytroopcount == 0:
#			if ownallies.resources >= troopcost:
#				producing = "troop"
#				eggtimer += 1
#				$EggTimer.setup(troopincubationtime)
#
#				ownallies.resources -= troopcost
		
		elif sqrt(ownallytroopcount) > ownallyforagercount and ownallies.resources >= foragercost:
			producing = "forager"
			eggtimer += 1
			$EggTimer.setup(foragerincubationtime)
			
			ownallies.resources -= foragercost
		
		
		elif ownallies.resources >= troopcost:
			producing = "troop"
			eggtimer += 1
			$EggTimer.setup(troopincubationtime)
			
			ownallies.resources -= troopcost
			
		elif ownallies.resources >= foragercost:
			producing = "forager"
			eggtimer += 1
			$EggTimer.setup(foragerincubationtime)
			
			ownallies.resources -= foragercost
		
	get_tree().call_group("Arena", "arena_update")


func antimation():
	animation = "LasiusGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
