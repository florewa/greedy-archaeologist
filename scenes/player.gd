extends CharacterBody2D

# --- НАСТРОЙКИ ---
var tile_size = 64 # Размер клетки в пикселях
var move_speed = 0.25 # Время перемещения на 1 клетку (в секундах)

# Ссылки на компоненты игрока
@onready var ray = $RayCast2D           # "Лазер" для проверки стен
@onready var anim = $AnimatedSprite2D   # Спрайт с анимациями

# Ссылка на карту тайлов (ищем её при старте)
var tile_map: TileMapLayer

# ID тайлов в TileSet (нужны для механики хрупкого пола)
var cracked_floor_source_id = 3 # ID треснувшего пола
var pit_source_id = 2           # ID ямы
var atlas_coords = Vector2i(0, 0)

# Флаги состояния
var is_moving = false   # Движется ли сейчас?
var can_move = false    # Разрешено ли управление?

func _ready():
	# Безопасно ищем карту уровня
	if get_parent().has_node("TileMapLayer"):
		tile_map = get_parent().get_node("TileMapLayer")
	
	anim.play("idle")
	
	# ХАК: Ждем 0.1 сек перед включением управления.
	# Это нужно, чтобы физический движок успел "построить" стены при загрузке уровня,
	# иначе игрок может пробежать сквозь стену на старте.
	await get_tree().create_timer(0.1).timeout
	can_move = true

# _process вызывается каждый кадр. Тут мы ловим нажатия кнопок.
func _process(_delta):
	# Если уже идем или управление отключено — игнорируем кнопки
	if is_moving or not can_move:
		return

	# Проверяем удержание клавиш (WASD или Стрелки)
	if Input.is_action_pressed("ui_right"):
		move(Vector2.RIGHT)
	elif Input.is_action_pressed("ui_left"):
		move(Vector2.LEFT)
	elif Input.is_action_pressed("ui_up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("ui_down"):
		move(Vector2.DOWN)

# Основная логика шага
func move(dir):
	# 1. ПРОВЕРКА ПРЕПЯТСТВИЙ
	# Направляем луч в соседнюю клетку
	ray.target_position = dir * tile_size
	ray.force_raycast_update() # Обновляем луч мгновенно
	
	# Если луч во что-то уперся (в стену)
	if ray.is_colliding():
		# Включаем анимацию стояния и выходим
		anim.play("idle")
		return

	# 2. НАЧАЛО ДВИЖЕНИЯ
	is_moving = true
	
	# Запоминаем, где стояли ДО шага (для механики ям)
	var old_tile_pos = Vector2i.ZERO
	if tile_map:
		old_tile_pos = tile_map.local_to_map(position)

	# 3. ВКЛЮЧАЕМ АНИМАЦИЮ БЕГА
	update_animation(dir)

	# 4. ПЛАВНОЕ ПЕРЕМЕЩЕНИЕ (TWEEN)
	var target_pos = position + dir * tile_size # Куда идем
	var tween = create_tween()
	# Плавно меняем позицию за время move_speed
	tween.tween_property(self, "position", target_pos, move_speed)
	
	# Ждем, пока анимация перемещения закончится
	await tween.finished
	
	# Жестко фиксируем позицию (чтобы не накапливались ошибки float координат)
	position = target_pos
	is_moving = false
	
	# Если игрок отпустил кнопки — сбрасываем в idle
	if not is_any_key_pressed():
		anim.play("idle")
	
	# 5. ЛОГИКА ХРУПКОГО ПОЛА
	if tile_map:
		check_break_floor(old_tile_pos)

# Функция отключения управления (вызывается при входе в дверь)
func disable_input():
	can_move = false
	anim.play("idle")

# Вспомогательная проверка: нажата ли хоть одна кнопка?
func is_any_key_pressed() -> bool:
	return Input.is_action_pressed("ui_right") or \
		   Input.is_action_pressed("ui_left") or \
		   Input.is_action_pressed("ui_up") or \
		   Input.is_action_pressed("ui_down")

# Выбор правильной анимации в зависимости от направления
func update_animation(dir):
	if dir == Vector2.UP:
		anim.play("walk_up")
	elif dir == Vector2.DOWN:
		anim.play("walk_down")
	elif dir == Vector2.LEFT:
		anim.play("walk_side")
		anim.flip_h = true # Отражаем спрайт (если нарисован вправо)
	elif dir == Vector2.RIGHT:
		anim.play("walk_side")
		anim.flip_h = false

# Проверка: если ушли с хрупкого пола — меняем его на яму
func check_break_floor(tile_pos):
	var source_id = tile_map.get_cell_source_id(tile_pos)
	if source_id == cracked_floor_source_id:
		# call_deferred меняет тайл в следующем кадре (безопасно для физики)
		tile_map.call_deferred("set_cell", tile_pos, pit_source_id, atlas_coords)
