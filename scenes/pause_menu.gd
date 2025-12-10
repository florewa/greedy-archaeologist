extends Control

func _ready():
	# При старте уровня меню должно быть скрыто
	hide()

# Обработка нажатий клавиш
func _input(event):
	# "ui_cancel" по умолчанию — это кнопка ESC
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

# Функция переключения режима паузы
func toggle_pause():
	# Переключаем видимость (было скрыто -> стало видно, и наоборот)
	visible = !visible
	
	# Ставим всю игру на паузу (или снимаем с неё)
	# Важно: Само меню должно иметь Process Mode = Always, чтобы работать в паузе
	get_tree().paused = visible

func _on_restart_button_pressed():
	# Сначала снимаем паузу, иначе перезагруженная сцена останется замороженной
	toggle_pause()
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	# Снимаем паузу
	toggle_pause()
	# Возвращаемся в главное меню
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
