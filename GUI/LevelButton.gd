extends TextureButton

onready var global = get_node("/root/Global")
export var levelnum = 0

func _on_LevelButton_pressed():
	get_parent().get_parent().enter_level(name)

func _ready():
	if not global.levelsbeaten[levelnum]: #If it is not beaten
		$LevelLines.modulate = Color(0.59,0.59,0.59,0)
	else:
		#$LevelLines.modulate = Color(0.3,0.3,1,1)
		pass
