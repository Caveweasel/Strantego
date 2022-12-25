extends "res://Entities/AntcestorGyne.gd"

var redstripes = false


func _ready():
#	self.texture = load("res://Sprites/Entities/GyneAlly.png")
#	$Highlight.texture = load("res://Sprites/Entities/GyneHighlight.png") #Assigns highlights's texture
	self.texture = null
	$Highlight.texture = null
	
	forager = load("res://Entities/AllyForager.tscn")
	foragercost = 10
	foragerincubationtime = 2
	troop = load("res://Entities/AllyTroop.tscn")
	troopcost = 20
	troopincubationtime = 3
	#occupiedtile = arena.arenalength
	
	shadow = get_node("AntmationsHD/Shadow")
	
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDLasiusGyne.tscn")
	antimation()
	tilescale = 2


func _input(_event):
	if selected and moved == false: #Only if this entity is selected and can move
		if Input.is_action_just_pressed("ui_left") and ownallies.resources >= foragercost:
			producing = "forager"
			eggtimer += 1
			moved = true
			selected = false
			$EggTimer.setup(foragerincubationtime)
			ownallies.resources -= foragercost
			get_tree().call_group("Arena", "arena_update")
			
		elif Input.is_action_just_pressed("ui_right") and ownallies.resources >= troopcost:
			producing = "troop"
			eggtimer += 1
			moved = true
			selected = false
			$EggTimer.setup(troopincubationtime)
			ownallies.resources -= troopcost
			get_tree().call_group("Arena", "arena_update")
			
		elif Input.is_action_just_pressed("ui_cancel"): #Deselect this entity and select another
			for i in ownallies.get_child_count(): #Only deselects this entity if there are others to select
				if ownallies.get_child(i).moveable:
					if not ownallies.get_child(i).moved:
						if not ownallies.get_child(i) == self:
							selected = false
							skipthisentity = true
							get_tree().call_group("Arena", "arena_update")
		elif Input.is_action_just_pressed("delete"): #Skips turn
#			if ownallies.resources < foragercost and ownallies.resources < troopcost:
				moved = true
				selected = false
				get_tree().call_group("Arena", "arena_update")


func do():
	if not dead:
		selected = true


func antimation():
	animation = "LasiusGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)


#	if ownallies.resources < foragercost and ownallies.resources < troopcost:
#		for i in ownallies.get_child_count(): #Only deselects this entity if there are others to select
#			if ownallies.get_child(i).moveable:
#				if not ownallies.get_child(i).moved:
#					if not ownallies.get_child(i) == self:
#						return
#		moved = true
#		selected = false
#		get_tree().call_group("Arena", "arena_update")


#func _process(_delta):
#	if not selected or moved:
#		for i in 2:
#			$WASDIcons.get_child(i).modulate = Color(0.3,0.3,1,0)
#		WASDiconsarevisible = false
#	elif not WASDiconsarevisible:
#		for i in 2:
#			#$WASDIcons.get_child(i).modulate = Color(0.3,0.3,1,1)
#			var colortween = $WASDIcons/ColorTween
#
#			colortween.interpolate_property($WASDIcons.get_child(i), "modulate",
#			$WASDIcons.get_child(i).modulate, Color(0.3,0.3,1,0.75), 0.25,
#			colortween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#			colortween.start()
#		WASDiconsarevisible = true


