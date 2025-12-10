extends CharacterBody2D

# Скорость передвижения (экспортируем, чтобы менять в редакторе)
@export var speed = 100

# Вектор направления движения (изначально вправо: x=1, y=0)
var direction = Vector2.RIGHT

# physics_process вызывается стабильно 60 раз в секунду (идеально для движения)
func _physics_process(delta):
	# Задаем скорость: Направление * Скорость
	velocity = direction * speed
	
	# move_and_slide перемещает тело и обрабатывает столкновения со стенами
	move_and_slide()
	
	# Если мумия врезалась в стену
	if is_on_wall():
		# Меняем направление на противоположное (умножаем на -1)
		direction = direction * -1
		
		# Зеркалим спрайт по горизонтали, чтобы мумия смотрела в нужную сторону
		# Если direction.x меньше 0 (влево), то flip_h = true
		$Sprite2D.flip_h = direction.x < 0

# Зона смерти (Area2D внутри мумии)
func _on_kill_area_body_entered(body):
	# Если в зону попал Игрок
	if body.is_in_group("player"):
		print("Игрок пойман! Перезагрузка...")
		# Перезапускаем текущий уровень заново
		get_tree().reload_current_scene()
