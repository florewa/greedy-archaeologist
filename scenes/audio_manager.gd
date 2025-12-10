extends Node

# Ссылки на плееры (один для музыки, один для звуков эффектов)
@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer

# Предзагрузка звуков в память (preload), чтобы они играли мгновенно без лагов
var coin_sound = preload("res://sounds/coin.wav")
var door_sound = preload("res://sounds/door.mp3")
var victory_sound = preload("res://sounds/victory.mp3") 

func _ready():
	# Если музыка еще не играет (при запуске игры), включаем её
	if not music_player.playing:
		music_player.play()

# Перезапуск фоновой музыки (используется в Главном Меню)
func restart_music():
	music_player.stop()
	music_player.play()

# Проигрывание звука монетки
func play_coin_sfx():
	sfx_player.stream = coin_sound
	sfx_player.play()

# Проигрывание звука двери
func play_door_sfx():
	sfx_player.stream = door_sound
	sfx_player.play()

# Проигрывание музыки победы
func play_victory_music():
	sfx_player.stream = victory_sound
	sfx_player.play()
