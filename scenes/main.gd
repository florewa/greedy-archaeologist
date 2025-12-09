extends Node2D

var total_coins = 0
var collected_coins = 0
var is_door_open = false # Флаг: открыта ли дверь?

# Ссылки на объекты в сцене
# Мы ищем узлы по их именам. Убедись, что в сцене они называются так же!
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var door_sprite = $Door/Sprite2D 
# ^ Если ты переименовывал дверь в сцене Main, поправь имя здесь (например $Door2 или просто $Door)

func _ready():
	# 1. Считаем, сколько всего монеток на уровне
	var coins_group = get_tree().get_nodes_in_group("coins")
	total_coins = coins_group.size()
	
	# 2. Подключаем каждую монетку к нашей функции
	for coin in coins_group:
		# Когда монетка испускает сигнал "collected", мы запускаем функцию _on_coin_collected
		# (Но этот сигнал нам надо создать в монетке, см. Шаг 5)
		coin.coin_collected.connect(_on_coin_collected)
	
	update_ui()

# Эта функция сработает, когда подберем монету
func _on_coin_collected():
	collected_coins += 1
	update_ui()
	
	# Проверка победы
	if collected_coins == total_coins:
		open_door()
		

func update_ui():
	score_label.text = "Сокровища: " + str(collected_coins) + " / " + str(total_coins)

func open_door():
	is_door_open = true
	print("Дверь открыта! Беги к выходу!")
	# Меняем картинку двери на открытую
	# Важно: убедись, что картинка door_open.png есть в папке и загрузи ее
	door_sprite.texture = load("res://sprites/door_open.png")
	

func _on_door_body_entered(body):
	# Если вошел Игрок И дверь открыта
	if body.is_in_group("player") and is_door_open:
		print("ПОБЕДА!")
		# Возвращаемся в главное меню (или на экран победы)
		call_deferred("change_scene")
		
func change_scene():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
