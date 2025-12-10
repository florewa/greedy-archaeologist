extends Control

# Нажатие кнопки "ИГРАТЬ"
func _on_play_pressed() -> void:
	# Загружаем первый уровень
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

# Нажатие кнопки "ВЫХОД"
func _on_quit_pressed() -> void:
	# Закрываем приложение
	get_tree().quit()
