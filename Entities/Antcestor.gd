extends Sprite

#Global variables
onready var gyne = get_parent().get_node("Gyne")
onready var arena = get_node("/root/BattleSceneTest")
onready var players = get_node("/root/BattleSceneTest/Players")
onready var ownallies = get_parent()
#Object variables
var occupiedtile = 4 #The tile this entity is occupying
var occupiedxtile = 0 #The X tile this entity is occupying
var occupiedytile = 0 #The Y tile this entity is occupying
#Entity variables
var health = 30
var strength = 20
var dead = false
#Player variables
var moveable = true #Can do an action f.eks. move
var selected = false
var moved = false
var skipthisentity = false #This entity won't be selected if this is true
var isAI = false
#In the canmove variables, 0 means they can't move to that position, 1 means they can, and 2 means they can attack
var shifting = false
var canmoveleft = 0
var canmoveright = 0
var canmoveup = 0
var canmovedown = 0
var canmoveupleft = 0
var canmoveupright = 0
var canmovedownright = 0
var canmovedownleft = 0
var highlightcolor = Color(0.3,0.3,1,0.25)

var canattack = true #If this entity can attack
var attacktimer = 0

var hasspacebarability = false #If this entity can do an action with the spacebar key f.eks. foragers can harvest with the spacebar key


func _ready():
#	position = gyne.position
	occupiedtile = gyne.occupiedtile
	position = arena.tiles[occupiedtile]
	self_modulate = Color(1,1,1,0)
	$Shadow.self_modulate = Color(1,1,1,0)
	if strength == 0:
		canattack = false
	if not hasspacebarability:
		$MovementCircles/WASDIcons/Spacebar.self_modulate = Color(0,0,0,0)
	is_AI()
	$MovementCircles.arena_update()


func arena_ready():
	position = arena.tiles[occupiedtile]
	arena_update()

func arena_update():
	
	if occupiedtile == gyne.occupiedtile:
		position = arena.tiles[occupiedtile]
	
#	if not isAI:
	var tween = $MovementTween
	tween.interpolate_property(self, "position",
	position, arena.tiles[occupiedtile], 0.5,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	update_occupied_tile()
	
	# FIX: CRASH AFTER GYNE DIES
	if not dead:
		
		if occupiedtile == gyne.occupiedtile and not selected and moved: #Hides itself if it is behind the gyne
			self_modulate = Color(1,1,1,0)
			$Shadow.self_modulate = Color(1,1,1,0)
	
		elif not occupiedtile == gyne.occupiedtile and self_modulate == Color(1,1,1,0): #Shows itself when moving away from the gyne
			var visibilitytween = $VisibilityTween
			visibilitytween.interpolate_property(self, "self_modulate",
			self_modulate, Color(1,1,1,1), 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			visibilitytween.start()
			
			var shadowtween = $Shadow/ShadowTween
			shadowtween.interpolate_property($Shadow, "self_modulate",
			$Shadow.self_modulate, Color(1,1,1,0.25), 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			shadowtween.start()



func movement_circles(a,b,c,d,e,f,g,h): #Detects which ways this entity can move
	canmoveleft = a
	canmoveright = b
	canmoveup = c
	canmovedown = d
	canmoveupleft = e
	canmoveupright = f
	canmovedownright = g
	canmovedownleft = h

func actually_attack(a,b,l,i):
	if not players.get_child(l).get_child(i).dead: #Only attack if the entity still exists
		players.get_child(l).get_child(i).damage(strength, self)
		moved = true
		selected = false
		attack((occupiedytile+a) * arena.arenalength + (occupiedxtile+b))
		get_tree().call_group("Arena", "arena_update")

func attack(attackedtile):
	var tween = $AttackTween
	if attacktimer == 0 and attackedtile != null:
		tween.interpolate_property(self, "position",
		position, position + (arena.tiles[attackedtile] - position) / 2, 0.25,
		Tween.TRANS_CUBIC, Tween.EASE_IN)
		tween.start()
		$AttackAnimationTimer.start()
	else:
		tween.stop(self, "position")
		tween.interpolate_property(self, "position",
		position, arena.tiles[occupiedtile], 0.25,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.start()

func conquer(tile): 
	occupiedtile = tile
	get_tree().call_group("Arena", "arena_update")


func _on_AttackAnimationTimer_timeout():
	attack(null)


func damage(damage, aggressor): #Takes damage
	health -= damage
	$AnimationTimer.start()
#	if damage >= health:
	if health <= 0:
		dead = true
		if aggressor != null:
			
			for i in ownallies.get_child_count(): #If there is an entity on this entity, don't get conquered
				if ownallies.get_child(i).occupiedtile == occupiedtile:
					if not ownallies.get_child(i) == self:
						return
			aggressor.conquer(occupiedtile)


func _on_AnimationTimer_timeout(): #Takes damage and animation
	if dead:
		var tween = $MovementTween
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
		
#		$AnimationTimer.wait_time = 0.5
		$AnimationTimer.start()
		yield($AnimationTimer, "timeout")
		
		get_tree().call_group("Arena", "arena_update")
		queue_free()


func _process(_delta):
	if not dead:
		if gyne.dead:
			dead = true
			$AnimationTimer.start()
	#		queue_free()


func update_occupied_tile():
	occupiedytile = ceil(float(occupiedtile / arena.arenalength)) #Finds out which Y tile this entity is occupying
	occupiedxtile = ceil(float(occupiedtile - occupiedytile * 5)) #Finds out which X tile this entity is occupying


func spacebar_ability():
	pass

func can_use_spacebar_ability():
	return false


func is_AI():
	pass

func AI():
	pass