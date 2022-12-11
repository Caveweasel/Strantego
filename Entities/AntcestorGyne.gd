extends Sprite

#Global variables
var shadow
onready var e = get_parent()
onready var players = get_node("/root/BattleSceneTest/Players")
onready var arena = get_node("/root/BattleSceneTest")
onready var ownallies = get_parent() #Which entities it is allies with
#Object variables
var value = 9999
var occupiedtile = 4 #The tile this entity is occupying
var occupiedxtile = 0 #The X tile this entity is occupying
var occupiedytile = 0 #The Y tile this entity is occupying
#Entity variables
var health = 60
var strength = 0
var dead = false
var attackable = true
var isAI = false
var isant = true
var animation
var animationplayer
var tilescale #How much space this entity takes up on the tile: 0 = XS, 1 = S, 2 = M...

var WASDiconsarevisible = false
var skipthisentity = false
var moved = false
var moveable = true #Can do an action f.eks. move
var selected = false
var thinking = false
var species = "Hi"
#Gyne variables
var eggtimer = 0 #How many turns this entity has been in production
var forager #Which entity this entity produces when producing a forager
var foragercost #How many resources it takes to produce a forager
var foragerincubationtime = 2 #The amount of turns a forager needs to be produced

var troop #Which entity this entity produces when producing a troop
var troopcost #How many resources it takes to produce a troop
var troopincubationtime = 3 #The amount of turns a troop needs to be produced

var producing = "null" #Which entity this entity is producing
var backlog = false #If this gyne has an entity on top, it will wait until it produces an entity
var shakeint = 0 #How far into the shake animation it is
var shakedistance = 16
var Aiconcolor = Color(0.3,0.3,1,0.75)
var Diconcolor = Color(0.3,0.3,1,0.75)
var isforager = false


func arena_ready():
	#position = arena.tiles[occupiedtile]
	occupiedtile = arena.tiles.find(position)
	occupiedytile = ceil(float(occupiedtile / arena.arenalength)) #Finds out which Y tile this entity is occupying
	occupiedxtile = ceil(float(occupiedtile - occupiedytile * arena.arenalength)) #Finds out which X tile this entity is occupying


func turn_update():
#	if ownallies == allies:
#		moved = false
	
#	if producing == "null" and isAI: #and ownallies.get_parent() == enemies:
#		AI()
	
	if arena.selectedcolony == get_parent():
		if producing == "forager": #If this gyne is producing a forager
			if eggtimer >= foragerincubationtime: #If enough turns have passed
				for i in ownallies.get_child_count(): #If there is an entity on this gyne, don't produce
					if ownallies.get_child(i).occupiedtile == occupiedtile:
						if not ownallies.get_child(i) == self:
							shake(-shakedistance, Tween.EASE_IN)
							backlog = true
				if not backlog:
					var newant = forager.instance()
					e.add_child(newant)
					newant.occupiedtile = occupiedtile
					newant.position = position
					producing = "null"
					eggtimer = 0
					if isAI:
						do()
			else: #If not enough turns have passed
				eggtimer += 1
		
		elif producing == "troop": #If this gyne is producing a troop
			if eggtimer >= troopincubationtime: #If enough turns have passed
				for i in ownallies.get_child_count(): #If there is an entity on this gyne, don't produce
					if ownallies.get_child(i).occupiedtile == occupiedtile:
						if not ownallies.get_child(i) == self:
							shake(-shakedistance, Tween.EASE_IN)
							backlog = true
				if not backlog:
					var newant = troop.instance()
					e.add_child(newant)
					newant.occupiedtile = occupiedtile
					newant.position = position
					producing = "null"
					eggtimer = 0
					if isAI:
						do()
			else: #If not enough turns have passed
				eggtimer += 1
		
		if not producing == "null": #If producing something
			moved = true
			selected = false
			get_tree().call_group("Arena", "arena_update")
	
	
	$EggTimer.egg_update(eggtimer)


func arena_update():
	
	if not visible:
		self_modulate = Color(1,1,1,0)
		visible = true
		$VisibilityTween.stop_all()
		var visibilitytween = $VisibilityTween
		visibilitytween.interpolate_property(self, "self_modulate",
		self_modulate, Color(1,1,1,1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		visibilitytween.start()
	
	
	if backlog: #If there isn't a backlog anymore, produce
		for i in ownallies.get_child_count(): #If there is an entity on this gyne, don't produce
			if ownallies.get_child(i).occupiedtile == occupiedtile:
				if not ownallies.get_child(i) == self:
					return
		
		if producing == "forager": #If this gyne is producing a forager
			var newant = forager.instance()
			e.add_child(newant)
			newant.occupiedtile = occupiedtile
			newant.position = position
			$EggTimer.reset()
			producing = "null"
			eggtimer = 0
			moved = false
			backlog = false
		
		elif producing == "troop": #If this gyne is producing a troop
			var newant = troop.instance()
			e.add_child(newant)
			newant.occupiedtile = occupiedtile
			newant.position = position
			$EggTimer.reset()
			producing = "null"
			eggtimer = 0
			moved = false
			backlog = false
	
	
	if ownallies.resources < foragercost:
		Aiconcolor = Color(0.5,0.5,0.5,0.75)
	elif Aiconcolor == Color(0.5,0.5,0.5,0.75):
		Aiconcolor = Color(0.3,0.3,1,0.75)
	
	if ownallies.resources < troopcost:
		Diconcolor = Color(0.5,0.5,0.5,0.75)
	else:
		Diconcolor = Color(0.3,0.3,1,0.75)


func damage(damage, aggressor): #Takes damage
	
	var damagelabel = load("res://Entities/DamageLabel.tscn").instance()
	arena.add_child(damagelabel)
	damagelabel.start(-damage, global_position)
	
	if damage >= health:
		dead = true
		
		for i in 2:
			$WASDIcons.get_child(i).modulate = Color(0.3,0.3,1,0)
		get_node("Highlight").visible = false
		
		if not aggressor == null:
			aggressor.conquer(occupiedtile)
	health -= damage
	$AnimationTimer.start()


func _on_AnimationTimer_timeout(): #Takes damage and animation
	if dead:
		var tween = $ShakeTween
		tween.interpolate_property(self, "position",
		position, position + Vector2(0, 128), 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		
		var visibilitytween = $VisibilityTween
		visibilitytween.interpolate_property(self, "self_modulate",
		self_modulate, Color(1,1,1,0), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		visibilitytween.start()
		
		var shadowtween = shadow.get_node("ShadowTween")
		shadowtween.interpolate_property(shadow, "self_modulate",
		shadow.self_modulate, Color(1,1,1,0), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		shadowtween.start()
		
		arena.check_gynes()
		$AnimationTimer.wait_time = 1
		$EggTimer.visible = false
		$AnimationTimer.start()
		yield($AnimationTimer, "timeout")
		
		get_tree().call_group("Arena", "arena_update")
		queue_free()
	else:
		var visibilitytween = $VisibilityTween
		visibilitytween.interpolate_property(self, "self_modulate",
		Color(1,0,0,1), self_modulate, 1,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
		visibilitytween.start()
#		get_parent().queue_free() #Removes this category


func shake(destination, easetype):
	var shaketween = $ShakeTween
	
	shaketween.stop_all()
	if easetype != null:
		shaketween.interpolate_property(self, "position",
		position, position + Vector2(destination,0), 0.2,
		shaketween.TRANS_QUAD, easetype)
		shaketween.start()
	else:
		shaketween.interpolate_property(self, "position",
		position, position + Vector2(destination,0), 0.2,
		shaketween.TRANS_QUAD)
		shaketween.start()
	
	if not shakeint >= 3:
		$ShakeTween/ShakeTimer.start()
	else:
		shakeint = 0


func _on_ShakeTimer_timeout():
	shakeint += 1
	if shakeint <= 1:
		shake(shakedistance*2, null)
	elif shakeint == 2:
		shake(-shakedistance*2, null)
	elif shakeint >= 3:
		shake(shakedistance, Tween.EASE_OUT)


func _process(_delta):
	if producing == "null":
		$EggTimer.reset()
	
	if not selected or moved:
		for i in 2:
			$WASDIcons.get_child(i).modulate = Color(0.3,0.3,1,0)
		get_node("Highlight").visible = false
		WASDiconsarevisible = false
	elif not WASDiconsarevisible:
#		for i in 2:
#			#$WASDIcons.get_child(i).modulate = Color(0.3,0.3,1,1)
#			var colortween = $WASDIcons/ColorTween
#			
#			colortween.interpolate_property($WASDIcons.get_child(i), "modulate",
#			$WASDIcons.get_child(i).modulate, WASDiconcolor, 0.25,
#			colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#			colortween.start()
		
		var colortween = $WASDIcons/ColorTween
		
		colortween.interpolate_property($WASDIcons.get_child(0), "modulate",
		$WASDIcons.get_child(0).modulate, Aiconcolor, 0.25,
		colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		colortween.start()
		
		colortween.interpolate_property($WASDIcons.get_child(1), "modulate",
		$WASDIcons.get_child(1).modulate, Diconcolor, 0.25,
		colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		colortween.start()
		
		
		WASDiconsarevisible = true
		get_node("Highlight").visible = true


func AI():
	pass


func do():
	pass


func antimation():
	pass
