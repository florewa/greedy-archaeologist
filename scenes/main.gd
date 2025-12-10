extends Node2D

# --- НАСТРОЙКИ УРОВНЯ ---
# Экспортная переменная позволяет выбирать файл следующего уровня прямо в Инспекторе Godot.
# "*.tscn" фильтрует файлы, показывая только сцены.
@export_file("*.tscn") var next_level_path: String

# --- ПЕРЕМЕННЫЕ ИГРЫ ---
var total_coins = 0      # Сколько всего монет на уровне
var collected_coins = 0  # Сколько уже собрали
var is_door_open = false # Флаг: открыт ли выход?

# Ссылки на узлы интерфейса и двери
# @onready гарантирует, что переменные заполнятся только когда сцена полностью загрузится
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var door_sprite = $Door/Sprite2D 

func _ready():
	# 1. Находим все узлы, которые находятся в группе "coins"
	var coins_group = get_tree().get_nodes_in_group("coins")
	total_coins = coins_group.size()
	
	# 2. Подключаем сигнал сбора от каждой монетки к функции _on_coin_collected
	for coin in coins_group:
		coin.coin_collected.connect(_on_coin_collected)
		
	# 3. Особый случай: если уровень без монет (обучение), дверь открываем сразу
	if total_coins == 0:
		open_door()
	
	# Обновляем текст на экране
	update_ui()

# Эта функция вызывается каждый раз, когда игрок подбирает монету
func _on_coin_collected():
	collected_coins += 1
	update_ui()
	
	# Если собрали всё — открываем дверь
	if collected_coins == total_coins:
		open_door()

# Логика открытия двери
func open_door():
	is_door_open = true
	# Меняем картинку закрытой двери на открытую
	door_sprite.texture = load("res://sprites/door_open.png")
	print("Дверь открыта!")
	# Играем звук открытия
	AudioManager.play_door_sfx()

# Обновление интерфейса (HUD)
func update_ui():
	if total_coins == 0:
		score_label.text = "Найди выход!"
	else:
		score_label.text = "Сокровища: " + str(collected_coins) + " / " + str(total_coins)

# --- ЛОГИКА ПЕРЕХОДА НА СЛЕДУЮЩИЙ УРОВЕНЬ ---
# Сигнал срабатывает, когда кто-то входит в зону Двери
func _on_door_body_entered(body):
	# Проверяем, что это Игрок И дверь уже открыта
	if body.is_in_group("player") and is_door_open:
		print("Уровень пройден!")
	
		# Отключаем управление игроку, чтобы он не убежал за карту во время загрузки
		if body.has_method("disable_input"):
			body.disable_input()
		
		# call_deferred откладывает загрузку на следующий кадр,
		# чтобы избежать ошибок физики во время обработки столкновения
		call_deferred("change_level")

# Функция смены сцены
func change_level():
	# Если в Инспекторе указан следующий уровень — грузим его
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
	else:
		# Если поле пустое (финал игры), возвращаемся в меню
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
