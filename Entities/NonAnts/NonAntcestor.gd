extends "res://Entities/EnemyAntcestor.gd"

func constructor():
	isant = false
	self_modulate = Color(1,1,1,1)


func _ready():
	gyne = self
	update_occupied_tile()
	$Shadow.self_modulate = Color(1,1,1,0)
	is_AI()
	antimation()
	$MovementCircles.arena_update()


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
	$AntmationsHD/AntimationPlayer.start_anim(null, "LasiusTroopIdle")

