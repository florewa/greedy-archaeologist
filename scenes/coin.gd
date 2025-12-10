extends Area2D

# Создаем свой сигнал, чтобы сообщить Уровню, что монетку подобрали
signal coin_collected

# Когда что-то входит в зону монетки
func _on_body_entered(body):
	# Проверяем, что это именно Игрок (а не враг)
	if body.is_in_group("player"):
		# 1. Просим AudioManager сыграть звук
		AudioManager.play_coin_sfx()
		# 2. Отправляем сигнал скрипту уровня
		coin_collected.emit()
		# 3. Удаляем монетку из мира
		queue_free()
