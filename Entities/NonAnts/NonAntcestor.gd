extends "res://Entities/EnemyAntcestor.gd"
var resourcegain = 20 #How many resources you get from killing it

func constructor():
	isant = false
	self_modulate = Color(1,1,1,1)


func _ready():
	gyne = self
	update_occupied_tile()
	#$Shadow.self_modulate = Color(1,1,1,0)
	is_AI()
	antimation()
	$MovementCircles.arena_update()
	
#	animationplayer = load("res://Entities/Animations/NonAntAnimations/AntmationsHDEarwig.tscn")
#	tilescale = 2
	shadow = get_node("AntmationsHD/Shadow")
	constructor()


func do():
#	$MovementCircles.detect_obstacles()
#	$MovementCircles.movement_update()
#	selected = true
	thinking = true
	yield(get_tree(), "idle_frame") #Wait one frame
	
	if not moved:
		moved = true
		selected = false
		$WaitTimer.start()
		yield($WaitTimer, "timeout")
		
		
		AI()
		update_occupied_tile()
		
		thinking = false
		get_tree().call_group("Arena", "arena_update") #Updates the arena to let everyone else know where this entity is
		
		var tween = $MovementTween
		tween.interpolate_property(self, "position",
		position, arena.tiles[occupiedtile], 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		
		
		$WaitTimer.start()
		yield($WaitTimer, "timeout")
	#	get_tree().call_group("Arena", "arena_update")


func antimation():
	animation = "EarwigIdle"
	$AntmationsHD/AntimationPlayer.start_anim(null, animation)


func damage(damage, aggressor): #Takes damage
	health -= damage
	
	var damagelabel = load("res://Entities/DamageLabel.tscn").instance()
	arena.add_child(damagelabel)
	damagelabel.start(-damage, global_position)
	
	$AnimationTimer.start()
#	if damage >= health:
	if health <= 0:
		dead = true
		moved = true
		selected = false
		$MovementCircles.modulate_circles()
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
			
			if aggressor.isant:
				$ResourceGainTimer.start()
				yield($ResourceGainTimer, "timeout")
				var resourcelabel = load("res://Entities/DamageLabel.tscn").instance()
				arena.add_child(resourcelabel)
				resourcelabel.change_type(Color(0,1,0), load("res://Sprites/Level/Resource.png"))
				resourcelabel.start(resourcegain, arena.tiles[occupiedtile])
				aggressor.ownallies.resources += resourcegain

