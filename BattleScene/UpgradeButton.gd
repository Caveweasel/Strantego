extends TextureButton

onready var allies = get_node("/root/BattleSceneTest/Players/Allies")
onready var arena = get_parent().get_parent().get_parent()
var alliesisselected = false


func check_pressable(currentselectedcolony):
	if currentselectedcolony == allies:
		disabled = false
		alliesisselected = true
	else:
		disabled = true
		alliesisselected = false
	check_if_forager()


func arena_ready():
	check_if_forager()

func arena_update():
	check_if_forager()


func check_if_forager():
	if alliesisselected:
		for i in allies.get_child_count(): 
			if allies.get_child(i).moveable:
				if not allies.get_child(i).moved and not allies.get_child(i).skipthisentity and not allies.get_child(i).dead and allies.get_child(i).selected:
					if allies.get_child(i).isforager:
						if allies.resources >= allies.get_child(i).satnestcost:
							var resources = arena.get_node("Resources")
							for b in resources.get_child_count():
								if allies.get_child(i).occupiedtile == resources.get_child(b).occupiedtile:
									disabled = false
									return
#		disabled = false


func check(e):
	if not e.isforager:
		disabled = true


