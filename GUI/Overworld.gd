extends Node2D

export var continent = "Test"
onready var global = get_node("/root/Global")

func _ready():
	$Camera2D/BlackSlideOut/BlackSlideOut.slide_out()
	$Camera2D/Money.text = str(global.money)
	var buttons = get_node("Buttons")
	for i in buttons.get_child_count():
		if global.levelsunlocked[i]:
			buttons.get_child(i).disabled = false

#
#func _on_Level3_pressed():
#	get_tree().change_scene("res://BattleScene/" + continent + "/Level0.tscn")

func enter_level(level):
	black_slide_in()
	yield($BlackScreenTimer, "timeout")
	global.cameray = $Camera2D.position.y
	get_tree().change_scene("res://BattleScene/" + continent + "/" + level + ".tscn")


func _on_CloseButton_pressed():
	black_slide_in()
	yield($BlackScreenTimer, "timeout")
	get_tree().change_scene("res://GUI/MainMenu.tscn")


func black_slide_in():
	var blackscreen = load("res://GUI/BlackSlideIn.tscn").instance()
	$Camera2D.add_child(blackscreen)
	blackscreen.get_child(0).rect_position = Vector2(-960,-540)
	blackscreen.get_child(0).slide_in()
	$BlackScreenTimer.start()
