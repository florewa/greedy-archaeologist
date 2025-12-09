extends CharacterBody2D

# Скорость мумии (можно менять в Инспекторе)
@export var speed = 100
# Направление движения (1 = вправо, -1 = влево)
var direction = Vector2.RIGHT

func _physics_process(delta):
	# Задаем скорость: направление * скорость
	velocity = direction * speed
	
	# Двигаем мумию (move_and_slide сама обрабатывает столкновения)
	move_and_slide()
	
	# Проверяем, ударилась ли мумия о стену
	if is_on_wall():
		# Если ударилась - меняем направление на противоположное
		direction = direction * -1
		
		# (Опционально) Отражаем картинку, чтобы смотрела в нужную сторону
		# $Sprite2D.flip_h = direction.x < 0


func _on_kill_area_body_entered(body):
	# Если тот, кто вошел в зону - это Игрок
	if body.is_in_group("player"):
		print("Игрок пойман! Перезагрузка...")
		# Перезагружаем текущую сцену (Game Over)
		get_tree().reload_current_scene()
