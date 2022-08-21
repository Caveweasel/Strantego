extends Sprite

#Global variables
onready var e = get_parent()
onready var players = get_node("/root/BattleSceneTest/Players")
onready var arena = get_node("/root/BattleSceneTest")
onready var ownallies = get_parent() #Which entities it is allies with
#Object variables
var occupiedtile = 4 #The tile this entity is occupying
var occupiedxtile = 0 #The X tile this entity is occupying
var occupiedytile = 0 #The Y tile this entity is occupying
#Entity variables
var health = 40
var dead = false
var isAI = false

var WASDiconsarevisible = false
var skipthisentity = false
var moved = false
var moveable = true #Can do an action f.eks. move
var selected = false
#Gyne variables
var eggtimer = 0 #How many turns this entity has been in production
var forager #Which entity this entity produces when producing a forager
var foragerincubationtime = 2 #The amount of turns a forager needs to be produced
var troop #Which entity this entity produces when producing a troop
var troopincubationtime = 3 #The amount of turns a troop needs to be produced
var producing = "null" #Which entity this entity is producing
var backlog = false #If this gyne has an entity on top, it will wait until it produces an entity
var shakeint = 0 #How far into the shake animation it is
var shakedistance = 16


func arena_ready():
	position = arena.tiles[occupiedtile]
	occupiedytile = ceil(float(occupiedtile / arena.arenalength)) #Finds out which Y tile this entity is occupying
	occupiedxtile = ceil(float(occupiedtile - occupiedytile * 5)) #Finds out which X tile this entity is occupying


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
					e.add_child(forager.instance())
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
					e.add_child(troop.instance())
					producing = "null"
					eggtimer = 0
					if isAI:
						do()
			else: #If not enough turns have passed
				eggtimer += 1
		
		if not producing == "null": #If producing something
			moved = true
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
			e.add_child(forager.instance())
			$EggTimer.reset()
			producing = "null"
			eggtimer = 0
			backlog = false
		
		elif producing == "troop": #If this gyne is producing a troop
			e.add_child(troop.instance())
			$EggTimer.reset()
			producing = "null"
			eggtimer = 0
			backlog = false

	


func damage(damage, aggressor): #Takes damage
	if damage >= health:
		dead = true
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
		
		var shadowtween = $Shadow/ShadowTween
		shadowtween.interpolate_property($Shadow, "self_modulate",
		$Shadow.self_modulate, Color(1,1,1,0), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		shadowtween.start()
		
		$AnimationTimer.wait_time = 1
		$EggTimer.visible = false
		$AnimationTimer.start()
		yield($AnimationTimer, "timeout")
		
		get_tree().call_group("Arena", "arena_update")
		queue_free()


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
		for i in 2:
			#$WASDIcons.get_child(i).modulate = Color(0.3,0.3,1,1)
			var colortween = $WASDIcons/ColorTween
			
			colortween.interpolate_property($WASDIcons.get_child(i), "modulate",
			$WASDIcons.get_child(i).modulate, Color(0.3,0.3,1,0.75), 0.25,
			colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			colortween.start()
		WASDiconsarevisible = true
		get_node("Highlight").visible = true


func AI():
	pass


func do():
	pass
