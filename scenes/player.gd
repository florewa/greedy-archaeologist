extends CharacterBody2D

var tile_size = 64
# Ссылка на наш "лазер", чтобы проверять стены
@onready var ray = $RayCast2D

# Словарь для конвертации нажатий в векторы
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(inputs[dir])

func move(dir):
	# 1. Поворачиваем "лазер" в сторону, куда хотим пойти
	# Мы умножаем на tile_size, чтобы луч бил ровно в центр соседней клетки
	ray.target_position = dir * tile_size
	
	# 2. Обновляем луч принудительно прямо сейчас (иначе он обновится только в следующем кадре)
	ray.force_raycast_update()
	
	# 3. Если луч НЕ столкнулся ни с чем (is_colliding() == false)
	if !ray.is_colliding():
		# То можно шагать
		position += dir * tile_size
