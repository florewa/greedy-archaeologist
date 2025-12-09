extends Node2D

# --- НАСТРОЙКИ УРОВНЯ ---
# Эта переменная появится в Инспекторе справа.
# В неё мы будем перетаскивать файл следующего уровня.
@export_file("*.tscn") var next_level_path: String

# --- ПЕРЕМЕННЫЕ ИГРЫ ---
var total_coins = 0
var collected_coins = 0
var is_door_open = false

# Ссылки на узлы (проверь, чтобы имена совпадали с твоей сценой!)
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var door_sprite = $Door/Sprite2D 

func _ready():
	# Считаем монеты
	var coins_group = get_tree().get_nodes_in_group("coins")
	total_coins = coins_group.size()
	
	# Подключаем сигналы монет
	for coin in coins_group:
		coin.coin_collected.connect(_on_coin_collected)
		
	# Если монет на уровне 0 (например, обучающий уровень без монет), сразу открываем дверь
	if total_coins == 0:
		open_door()
	
	update_ui()

# Когда собрали монету
func _on_coin_collected():
	collected_coins += 1
	update_ui()
	
	if collected_coins == total_coins:
		open_door()

# Открытие двери (визуал)
func open_door():
	is_door_open = true
	# Убедись, что путь к картинке правильный
	door_sprite.texture = load("res://sprites/door_open.png")
	print("Дверь открыта!")

# Обновление текста
func update_ui():
	# Если монет нет вообще, пишем "Беги к выходу"
	if total_coins == 0:
		score_label.text = "Найди выход!"
	else:
		score_label.text = "Сокровища: " + str(collected_coins) + " / " + str(total_coins)

# --- ЛОГИКА ПЕРЕХОДА ---
# Этот сигнал должен быть подключен от узла Door к этому скрипту
func _on_door_body_entered(body):
	if body.is_in_group("player") and is_door_open:
		print("Уровень пройден!")
		# Вызываем переход с небольшой задержкой (чтобы не было багов физики)
		call_deferred("change_level")

func change_level():
	# Проверяем, указан ли следующий уровень
	if next_level_path != "":
		# Если указан -> грузим его
		get_tree().change_scene_to_file(next_level_path)
	else:
		# Если поле пустое (например, это 5-й уровень) -> идем в Главное Меню
		# Убедись, что путь к меню правильный!
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
