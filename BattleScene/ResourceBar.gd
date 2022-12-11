extends TextureProgress

onready var resourcemanager = get_node("/root/BattleSceneTest/Players/Allies")
onready var resourcelabel = get_node("/root/BattleSceneTest/ResourceLabel")

func arena_update():
	update()

func arena_ready():
	max_value = resourcemanager.maxresources
	update()


func update():
	value = resourcemanager.resources
	resourcelabel.text = str(value)
	
