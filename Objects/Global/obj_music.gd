extends Node2D

var roomname = ""
var music
var secretmusic
var secret = false
onready var musicnode = $music
onready var secretmusicnode = $secretmusic

# This array is arranged the following way:
#   room name      song name      secret song name     set song position at previous songs position
var room_arr = [
	["Realtitlescreen", "mu_title", "mu_medievalsecret", false],
	["Titlescreen", "mu_title", "mu_medievalsecret", false],
	["hub_room1", "mu_hub", "mu_medievalsecret", false],
	["entrance_1", "mu_entrance", "mu_medievalsecret", false],
	["testroom_1", "mu_medieval", "mu_medievalsecret", false]
]

func room_start():
	if (!global.panic):
		for i in room_arr.size():
			var b = room_arr[i]
			if (global.targetRoom == b[0]):
				var prevmusic = music
				var oldmusicpos = $music.get_playback_position()
				music = b[1]
				secretmusic = b[2]
				if (music != prevmusic):
					var newmusic = load("res://Music/" + music + ".ogg")
					$music.stream = newmusic
					if (b[3]):
						$music.play(oldmusicpos)
					else:
						$music.play()
				$RestartMusicTimer.start()
	if ("secret" in global.targetRoom):
		secret = true
	else:
		secret = false
	if (secret):
		var newsecretmusic = load("res://Music/" + secretmusic + ".ogg")
		var musicpos = $music.get_playback_position()
		$secretmusic.stream = newsecretmusic
		$secretmusic.play(musicpos)
		$music.stream_paused = true
	else:
		if ($music.stream_paused):
			$music.stream_paused = false
		$secretmusic.stop()
	if (global.targetRoom == "rank_room"):
		$music.stop()
		$secretmusic.stop()
		
func _process(delta):
	if (secret):
		if (!$secretmusic.playing):
			var newsecretmusic = load("res://Music/" + secretmusic + ".ogg")
			var musicpos = $music.get_playback_position()
			$secretmusic.stream = newsecretmusic
			$secretmusic.play(musicpos)
		$music.stream_paused = true
	elif (!secret):
		if ($music.stream_paused):
			$music.stream_paused = false
		$secretmusic.stop()
	if (global.panic):
		if (music != "mu_pizzatime"):
			music = "mu_pizzatime"
			var newmusic = load("res://Music/" + music + ".ogg")
			$music.stream = newmusic
			$music.play()

func _on_RestartMusicTimer_timeout():
	if (!$music.playing):
		$music.play()
