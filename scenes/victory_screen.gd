extends Control

func _ready():
	# Запускаем победную музыку
	AudioManager.play_victory_music()

func _on_button_pressed():
	# Возвращаемся в главное меню
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
