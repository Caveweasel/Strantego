extends Node2D

#Global variables
var shadow
onready var players = get_node("/root/BattleSceneTest/Players")
onready var arena = get_node("/root/BattleSceneTest")
onready var ownallies = get_parent() #Which entities it is allies with
#Object variables
var value = 1000
var occupiedtile = 1 #The tile this entity is occupying
var occupiedxtile = 0
var occupiedytile = 0
#Entity variables
var skipthisentity = false
var thinking = false
var dead = false
var health = 40
var strength = 0
var species = "Bob"
var animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDflavusGyne.tscn")
var animation
var attackable = true
var isAI = false
var isant = true
var moved = true
var selected = false
var moveable = false
var tilescale = 2

var backlog
var eggtimer = 0 #How many turns this entity has been in production


var troop = load("res://Entities/Ants/Lasius/LflavusAllyTroop.tscn") #Which entity this entity produces when producing a troop
var troopcost = 20 #How many resources it takes to produce a troop
var troopincubationtime = 3 #The amount of turns a troop needs to be produced

var foragerefficiency = 0.4
var resourcecount = 20
var resourcesperturn = 10

var producing = "null" #Which entity this entity is producing
var shakeint = 0 #How far into the shake animation it is
var shakedistance = 16
var isforager = false


func _ready():
	var resources = arena.get_node("Resources")
	for b in resources.get_child_count(): #For every resource
		if resources.get_child(b).position == position:
			resourcesperturn = resources.get_child(b).resources
	constructor()
	antimation()


func antimation():
	animation = "LasiusGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(null, animation)


func constructor():
	pass


func arena_ready():
	occupiedtile = arena.tiles.find(position)
#	position = arena.tiles[occupiedtile]
	occupiedytile = ceil(float(occupiedtile / arena.arenalength)) #Finds out which Y tile this entity is occupying
	occupiedxtile = ceil(float(occupiedtile - occupiedytile * arena.arenalength)) #Finds out which X tile this entity is occupying


func turn_update():
#	if ownallies == allies:
#		moved = false
	
#	if producing == "null" and isAI: #and ownallies.get_parent() == enemies:
#		AI()
	
	
	moved = true
	selected = false
	#do()
	
	if arena.selectedcolony == get_parent():
		resourcecount += resourcesperturn * foragerefficiency
		print(resourcecount)
		print(producing)
		if producing == "troop": #If this gyne is producing a troop
			if eggtimer >= troopincubationtime: #If enough turns have passed
				for i in ownallies.get_child_count(): #If there is an entity on this gyne, don't produce
					if ownallies.get_child(i).occupiedtile == occupiedtile:
						if not ownallies.get_child(i) == self:
							shake(-shakedistance, Tween.EASE_IN)
							backlog = true
				if not backlog:
					var newant = troop.instance()
					ownallies.add_child(newant)
					newant.occupiedtile = occupiedtile
					newant.position = position
					producing = "null"
					eggtimer = 0
					#if isAI:
					$EggTimer.reset()
					do()
			else: #If not enough turns have passed
				eggtimer += 1
		
		if not producing == "null": #If producing something
			#moved = true
			#selected = false
			get_tree().call_group("Arena", "arena_update")
		
		else:
			do()
		
	
	
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
		
		if producing == "troop": #If this gyne is producing a troop
			var newant = troop.instance()
			ownallies.add_child(newant)
			newant.occupiedtile = occupiedtile
			newant.position = position
			$EggTimer.reset()
			producing = "null"
			eggtimer = 0
			backlog = false
		
		do()


func do():
	if resourcecount >= troopcost and producing == "null":
		producing = "troop"
		eggtimer += 1
		$EggTimer.setup(troopincubationtime)
		
		resourcecount -= troopcost
		get_tree().call_group("Arena", "arena_update")
		#resourcecount -= troopcost


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


func damage(damage, aggressor): #Takes damage
	health -= damage
	
	var damagelabel = load("res://Entities/DamageLabel.tscn").instance()
	arena.add_child(damagelabel)
	damagelabel.start(-damage, global_position)
	
	$AnimationTimer.start()
#	if damage >= health:
	if health <= 0:
		dead = true
		if aggressor != null:
			
			for l in players.get_child_count(): #If there is an entity/obstacle on this entity, don't get conquered
				for i in players.get_child(l).get_child_count(): 
					if players.get_child(l).get_child(i).occupiedtile == occupiedtile:
						if not players.get_child(l).get_child(i) == self:
							return
			
#			for i in ownallies.get_child_count(): #If there is an entity on this entity, don't get conquered
#				if ownallies.get_child(i).occupiedtile == occupiedtile:
#					if not ownallies.get_child(i) == self:
#						return
			aggressor.conquer(occupiedtile)


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


func _process(_delta):
	if producing == "null":
		$EggTimer.reset()


func _on_DeathTimer_timeout():
	queue_free()
