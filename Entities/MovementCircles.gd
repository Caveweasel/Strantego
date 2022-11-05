extends Node2D

#Global variables
onready var e = get_parent()
#onready var gyne = e.get_parent().get_node("Gyne")
var gyne
onready var arena = get_node("/root/BattleSceneTest")
onready var players = get_node("/root/BattleSceneTest/Players")
onready var ownallies = get_parent().get_parent() #Which entities it is allies with
#Mover variables #In the canmove variables, 0 means they can't move to that position, 1 means they can, and 2 means there's an enemy, and 3 means there is a neutral entity
var canmoveleft = 0
var canmoveright = 0
var canmoveup = 0
var canmovedown = 0
var canmoveupleft = 0
var canmoveupright = 0
var canmovedownright = 0
var canmovedownleft = 0
#MovementCircles variables
var showcircles = false #For AI to show circles
var moveablearea = Color(0.3,0.3,1,0.25) #The color of the circle when this entity can move there
var immoveablearea = Color(0.5,0.5,0.5,0.25) #The color of the circle when there is an obstacle
var offlimitsarea = Color(0,0,0,0) #The color of the circle when the area is off limits or when the entity isn't selected
var attackablearea = Color(1,0.2,0.2,0.25) #The color of the circle when there is an attackable entity
var WASDiconmodifier = Color(0,0,0,0.75) #Adds this color to the movementcircles to get the WASDIcon's colors
var WASDiconofflimits = Color(0.5,0.5,0.5,0) #The color the WASDIcons are when they are in a off limits area
var circlesarevisible = false


func _ready():
#	for i in 8:
#		get_child(i).self_modulate = moveablearea #Makes all of the circles visible
	#Makes the circles invisible
	for i in 8:
		get_child(i).visible = false
	for i in 5:
		$WASDIcons.get_child(i).visible = false
	e.get_node("Highlight").visible = false
	circlesarevisible = false
#	if e.occupiedtile == gyne.occupiedtile:
#		e.canattack = false

func arena_ready():
	arena_update()


func arena_update():
	canmoveleft = 1
	canmoveright = 1
	canmoveup = 1
	canmovedown = 1
	
	for i in 8:
		get_child(i).self_modulate = moveablearea #Makes all of the circles visible
	
	detect_obstacles()
	movement_update()
#	modulate_circles()
#	e.movement_circles(canmoveleft,canmoveright,canmoveup,canmovedown,canmoveupleft,canmoveupright,canmovedownright,canmovedownleft)
	
#	if e.occupiedtile == gyne.occupiedtile:
#		e.canattack = false
#	else:
#		e.canattack = true



func detect_obstacles(): #Detects obstacles
#	var tilemap = get_node("/root/BattleSceneTest/TileMap")
	
	var currentxtile = e.occupiedxtile
	var currentytile = e.occupiedytile
	
	for i in 4:
		get_child(i+4).self_modulate = offlimitsarea #Makes all of the diagonal circles invisible
	
	
	#Makes the circles invisible if it is off of the arena
	if currentxtile == 0:
		get_child(0).self_modulate = offlimitsarea
		canmoveleft = 0
	elif currentxtile == arena.arenalength - 1:
		get_child(1).self_modulate = offlimitsarea
		canmoveright = 0
	if currentytile == 0:
		get_child(2).self_modulate = offlimitsarea
		canmoveup = 0
	elif currentytile == arena.arenawidth - 1:
		get_child(3).self_modulate = offlimitsarea
		canmovedown = 0
	
#	#Makes the circles grey if there is a rock
#	if tilemap.get_cell(currentxtile-1, currentytile) == 1:
#		get_child(0).self_modulate = immoveablearea
#		canmoveleft = 0
#	if tilemap.get_cell(currentxtile+1, currentytile) == 1:
#		get_child(1).self_modulate = immoveablearea
#		canmoveright = 0
#	if tilemap.get_cell(currentxtile, currentytile-1) == 1:
#		get_child(2).self_modulate = immoveablearea
#		canmoveup = 0
#	if tilemap.get_cell(currentxtile, currentytile+1) == 1:
#		get_child(3).self_modulate = immoveablearea
#		canmovedown = 0


func movement_update(): #Detects entities
	
	var currentxtile = e.occupiedxtile
	var currentytile = e.occupiedytile
	
	
	
	#Makes the circles grey if there is an ally
	for i in ownallies.get_child_count():
		if ownallies.get_child(i).occupiedxtile == currentxtile - 1 and ownallies.get_child(i).occupiedytile == currentytile and not ownallies.get_child(i).dead:
			get_child(0).self_modulate = immoveablearea
			canmoveleft = 0
		elif ownallies.get_child(i).occupiedxtile == currentxtile + 1 and ownallies.get_child(i).occupiedytile == currentytile and not ownallies.get_child(i).dead:
			get_child(1).self_modulate = immoveablearea
			canmoveright = 0
		elif ownallies.get_child(i).occupiedytile == currentytile - 1 and ownallies.get_child(i).occupiedxtile == currentxtile and not ownallies.get_child(i).dead:
			get_child(2).self_modulate = immoveablearea
			canmoveup = 0
		elif ownallies.get_child(i).occupiedytile == currentytile + 1 and ownallies.get_child(i).occupiedxtile == currentxtile and not ownallies.get_child(i).dead:
			get_child(3).self_modulate = immoveablearea
			canmovedown = 0
	
	#Makes all of the diagonal circles immovable
	canmoveupleft = 0
	canmovedownleft = 0
	canmoveupright = 0
	canmovedownright = 0
	
	#Makes the circles red if there is an enemy
	for l in players.get_child_count():
		if not players.get_child(l) == ownallies: #If it isn't its own colony
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == currentxtile - 1 and players.get_child(l).get_child(i).occupiedytile == currentytile and not players.get_child(l).get_child(i).dead:
					if e.canattack and players.get_child(l).get_child(i).attackable:
						get_child(0).self_modulate = attackablearea
						canmoveleft = 2
					else:
						get_child(0).self_modulate = immoveablearea
						canmoveleft = 0
				elif players.get_child(l).get_child(i).occupiedxtile == currentxtile + 1 and players.get_child(l).get_child(i).occupiedytile == currentytile and not players.get_child(l).get_child(i).dead:
					if e.canattack and players.get_child(l).get_child(i).attackable:
						get_child(1).self_modulate = attackablearea
						canmoveright = 2
					else:
						get_child(1).self_modulate = immoveablearea
						canmoveright = 0
				elif players.get_child(l).get_child(i).occupiedytile == currentytile - 1 and players.get_child(l).get_child(i).occupiedxtile == currentxtile and not players.get_child(l).get_child(i).dead:
					if e.canattack and players.get_child(l).get_child(i).attackable:
						get_child(2).self_modulate = attackablearea
						canmoveup = 2
					else:
						get_child(2).self_modulate = immoveablearea
						canmoveup = 0
				elif players.get_child(l).get_child(i).occupiedytile == currentytile + 1 and players.get_child(l).get_child(i).occupiedxtile == currentxtile and not players.get_child(l).get_child(i).dead:
					if e.canattack and players.get_child(l).get_child(i).attackable:
						get_child(3).self_modulate = attackablearea
						canmovedown = 2
					else:
						get_child(3).self_modulate = immoveablearea
						canmovedown = 0
			
			#Makes the diagonal circles red if there is an enemy
			if e.canattack:
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == currentxtile - 1 and players.get_child(l).get_child(i).occupiedytile == currentytile - 1 and not players.get_child(l).get_child(i).dead and players.get_child(l).get_child(i).attackable:
						get_child(4).self_modulate = attackablearea
						canmoveupleft = 2
					elif players.get_child(l).get_child(i).occupiedytile == currentytile + 1 and players.get_child(l).get_child(i).occupiedxtile == currentxtile + 1 and not players.get_child(l).get_child(i).dead and players.get_child(l).get_child(i).attackable:
						get_child(5).self_modulate = attackablearea
						canmovedownright = 2
					elif players.get_child(l).get_child(i).occupiedxtile == currentxtile + 1 and players.get_child(l).get_child(i).occupiedytile == currentytile - 1 and not players.get_child(l).get_child(i).dead and players.get_child(l).get_child(i).attackable:
						get_child(6).self_modulate = attackablearea
						canmoveupright = 2
					elif players.get_child(l).get_child(i).occupiedytile == currentytile + 1 and players.get_child(l).get_child(i).occupiedxtile == currentxtile - 1 and not players.get_child(l).get_child(i).dead and players.get_child(l).get_child(i).attackable:
						get_child(7).self_modulate = attackablearea
						canmovedownleft = 2
	
	
#	if e.isAI:
#		e.AI()
	
	#Makes the circles invisible
	for i in 8:
		get_child(i).visible = false
	for i in 5:
		$WASDIcons.get_child(i).visible = false
	e.get_node("Highlight").visible = false
	circlesarevisible = false
	
	
	
#	modulate_circles()
	e.movement_circles(canmoveleft,canmoveright,canmoveup,canmovedown,canmoveupleft,canmoveupright,canmovedownright,canmovedownleft)


func _process(_delta):
	modulate_circles()


func modulate_circles():
#	if not e.selected or e.moved or e.isAI and showcircles: #Removes circles if the entity isn't selected or has moved
#		pass
#		for i in 8:
#			get_child(i).visible = false
#		for i in 5:
#			$WASDIcons.get_child(i).self_modulate = WASDiconofflimits
#		e.get_node("Highlight").visible = false
#		circlesarevisible = false
	
	if not circlesarevisible and e.selected and not e.moved or showcircles:
		for i in 8:
			get_child(i).visible = true #Makes all of the circles visible
		for i in 5:
			$WASDIcons.get_child(i).visible = true
#		detect_obstacles()
#		movement_update()
		circlesarevisible = true
#		if not e.occupiedtile == gyne.occupiedtile:
#			e.get_node("Highlight").visible = true
		e.get_node("Highlight").visible = true
		if e.occupiedtile == gyne.occupiedtile:
			gyne.visible = false
			e.self_modulate = Color(1,1,1,1)
			e.shadow.self_modulate = Color(1,1,1,0.25)
		
		#Moves the WASDIcons to their correct positions and makes them the correct color
		if not e.isAI:
			if Input.is_action_pressed("shift"):
				for i in 4:
					var movementtween = $WASDIcons/WASDMovementTween
					movementtween.interpolate_property($WASDIcons.get_child(i), "position",
					$WASDIcons.get_child(i).position, get_child(i+4).position, 0.25,
					Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					movementtween.start()
					
					$WASDIcons.get_child(i).self_modulate = get_child(i).self_modulate * Color(1,1,1,0) #Makes the color fade in look nicer
					var colortween = $WASDIcons/WASDColorTween
					if get_child(i+4).self_modulate == offlimitsarea:
						colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
						$WASDIcons.get_child(i).self_modulate, WASDiconofflimits, 0.25,
						colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
						colortween.start()
					else:
						colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
						$WASDIcons.get_child(i).self_modulate, get_child(i+4).self_modulate + WASDiconmodifier, 0.25,
						colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
						colortween.start()
					e.shifting = true
			
			else:
				for i in 4:
					var movementtween = $WASDIcons/WASDMovementTween
					movementtween.interpolate_property($WASDIcons.get_child(i), "position",
					$WASDIcons.get_child(i).position, get_child(i).position, 0.25,
					movementtween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					movementtween.start()
					
					$WASDIcons.get_child(i).self_modulate = get_child(i).self_modulate * Color(1,1,1,0) #Makes the color fade in look nicer
					var colortween = $WASDIcons/WASDColorTween
					if get_child(i).self_modulate == offlimitsarea:
						colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
						$WASDIcons.get_child(i).self_modulate, WASDiconofflimits, 0.25,
						colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
						colortween.start()
					else:
						colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
						$WASDIcons.get_child(i).self_modulate, get_child(i).self_modulate + WASDiconmodifier, 0.25,
						colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
						colortween.start()
					e.shifting = false
		
		else: #If it is an AI don't move the WASD Icons when shifting
			for i in 4:
				var movementtween = $WASDIcons/WASDMovementTween
				movementtween.interpolate_property($WASDIcons.get_child(i), "position",
				$WASDIcons.get_child(i).position, get_child(i).position, 0.25,
				movementtween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				movementtween.start()
				
				$WASDIcons.get_child(i).self_modulate = get_child(i).self_modulate * Color(1,1,1,0) #Makes the color fade in look nicer
				var colortween = $WASDIcons/WASDColorTween
				if get_child(i).self_modulate == offlimitsarea:
					colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
					$WASDIcons.get_child(i).self_modulate, WASDiconofflimits, 0.25,
					colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					colortween.start()
				else:
					colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
					$WASDIcons.get_child(i).self_modulate, get_child(i).self_modulate + WASDiconmodifier, 0.25,
					colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					colortween.start()
				e.shifting = false
		
		
		
		if e.hasspacebarability and e.can_use_spacebar_ability(): #If this entity has and can use its spacebar ability
			var colortween = $WASDIcons/WASDColorTween
			colortween.interpolate_property($WASDIcons.get_child(4), "self_modulate",
			$WASDIcons.get_child(4).self_modulate, moveablearea + WASDiconmodifier, 0.25,
			colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			colortween.start()
		else:
			$WASDIcons.get_child(4).self_modulate = offlimitsarea
		showcircles = false
	
	
	
	#Moves the WASDIcons to their correct positions and makes them the correct color
	if not e.isAI:
		if Input.is_action_just_pressed("shift"):
			for i in 4:
				var movementtween = $WASDIcons/WASDMovementTween
				movementtween.interpolate_property($WASDIcons.get_child(i), "position",
				$WASDIcons.get_child(i).position, get_child(i+4).position, 0.25,
				Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				movementtween.start()
				
				var colortween = $WASDIcons/WASDColorTween
				if get_child(i+4).self_modulate == offlimitsarea:
					colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
					$WASDIcons.get_child(i).self_modulate, WASDiconofflimits, 0.25,
					colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					colortween.start()
				else:
					colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
					$WASDIcons.get_child(i).self_modulate, get_child(i+4).self_modulate + WASDiconmodifier, 0.25,
					colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					colortween.start()
				e.shifting = true
		
		if Input.is_action_just_released("shift"):
			for i in 4:
				var movementtween = $WASDIcons/WASDMovementTween
				movementtween.interpolate_property($WASDIcons.get_child(i), "position",
				$WASDIcons.get_child(i).position, get_child(i).position, 0.25,
				movementtween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				movementtween.start()
				
				var colortween = $WASDIcons/WASDColorTween
				if get_child(i).self_modulate == offlimitsarea:
					colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
					$WASDIcons.get_child(i).self_modulate, WASDiconofflimits, 0.25,
					colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					colortween.start()
				else:
					colortween.interpolate_property($WASDIcons.get_child(i), "self_modulate",
					$WASDIcons.get_child(i).self_modulate, get_child(i).self_modulate + WASDiconmodifier, 0.25,
					colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					colortween.start()
				e.shifting = false


#func circlesvisible():
#	for i in 8:
#		get_child(i).self_modulate = moveablearea #Makes all of the circles visible
#	detect_obstacles()
#	movement_update()
#	circlesarevisible = true
#	if not e.occupiedtile == gyne.occupiedtile:
#		e.get_node("Highlight").visible = true


