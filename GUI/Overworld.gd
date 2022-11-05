extends Node2D

export var continent = "Test"

#
#func _on_Level3_pressed():
#	get_tree().change_scene("res://BattleScene/" + continent + "/Level0.tscn")

func enter_level(level):
	get_tree().change_scene("res://BattleScene/" + continent + "/" + level + ".tscn")


func _on_CloseButton_pressed():
	get_tree().change_scene("res://GUI/MainMenu.tscn")
