extends StaticBody2D

# Эта функция вызывается по сигналу от Плиты (Plate)
func open_gate():
	print("ВОРОТА ОТКРЫВАЮТСЯ!")
	
	# 1. Меняем картинку на "убранные шипы" (безопасно)
	$Sprite2D.texture = load("res://sprites/spikes_off.png")
	
	# 2. Выключаем физическую коллизию
	# set_deferred обязательно нужен для физики, чтобы не вызвать ошибку
	# если изменение произошло прямо во время просчета столкновения.
	$CollisionShape2D.set_deferred("disabled", true)

# Заготовка под сигнал (не используется, так как мы соединяем через редактор)
func _on_plate_activated() -> void:
	pass
