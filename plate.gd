extends Area2D

# Создаем сигнал, который полетит наружу
signal activated

var is_pressed = false

func _on_body_entered(body):
	# Если наступил игрок и плита еще не нажата
	if body.is_in_group("player") and not is_pressed:
		is_pressed = true
		# Меняем картинку на нажатую
		# Убедись, что plate_down.png есть в папке
		$Sprite2D.texture = load("res://sprites/plate_down.png")
		
		# Кричим "Меня нажали!"
		activated.emit()
