extends Area2D

# Сигнал, который мы посылаем Воротам
signal activated

# Флаг, чтобы плита нажималась только один раз
var is_pressed = false

func _on_body_entered(body):
	# Если наступил Игрок И плита еще не нажата
	if body.is_in_group("player") and not is_pressed:
		print("ПЛИТА НАЖАТА!")
		is_pressed = true
		
		# Меняем текстуру на нажатую
		$Sprite2D.texture = load("res://sprites/plate_down.png")
		
		# Испускаем сигнал (ворота его "услышат" и откроются)
		activated.emit()
