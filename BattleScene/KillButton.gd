extends TextureButton

onready var allies = get_node("/root/BattleSceneTest/Players/Allies")
var alliesisselected = false


func check_pressable(currentselectedcolony):
	if currentselectedcolony == allies:
		disabled = false
		alliesisselected = true
	else:
		disabled = true
		alliesisselected = false
	check_if_gyne()


func arena_ready():
	check_if_gyne()

func arena_update():
	check_if_gyne()


func check_if_gyne():
	if alliesisselected:
		for i in allies.get_child_count(): 
			if allies.get_child(i).moveable:
				if not allies.get_child(i).moved and not allies.get_child(i).skipthisentity and not allies.get_child(i).dead:
					if allies.get_child(i) == allies.get_node("Gyne"):
						disabled = true
						return
					disabled = false
					return
#		disabled = false


func check(e):
	if e == allies.get_node("Gyne"):
		disabled = true


#func _process(_delta):
#	if not get_node("/root/BattleSceneTest/NextTurnButton").disabled:
#		disabled = true
