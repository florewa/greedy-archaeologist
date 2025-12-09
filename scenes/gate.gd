extends StaticBody2D

# Функция, которая уберет стену
func open_gate():
	queue_free() # Просто удаляем объект из игры
