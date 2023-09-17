extends Node

onready var GameNode = get_node(@"/root/Game")

func randi_range(from, to):
	if from > to:
		var old_from = from
		from = to
		to = old_from
	return int(floor(rand_range(from , to + 1)))
	
func instance_create(x, y, scene):
	var loadedscene = load(scene)
	var id = loadedscene.instance()
	GameNode.add_child(id)
	id.position = Vector2(x, y)
	return id
	
func instance_exists(node):
	var instancenode = GameNode.get_node_or_null(node)
	if instancenode == null:
		return false
	else:
		return true
		
func instance_exists_level(node):
	if (get_level() != null):
		var instancenode = get_level().get_node_or_null(node)
		if instancenode == null:
			return false
		else:
			return true
	else:
		return false
		
func get_instance(node):
	var instancenode = GameNode.get_node_or_null(node)
	return instancenode
	
func get_instance_level(node):
	var instancenode = get_level().get_node_or_null(node)
	return instancenode
	
func get_gamenode():
	return GameNode
	
func playsound(soundname):
	if GameNode.get_node_or_null(soundname) != null:
		GameNode.get_node(soundname).play()
	else:
		print("playsound: Sound " + soundname + " does not exist!")
		
func stopsound(soundname):
	if GameNode.get_node_or_null(soundname) != null:
		GameNode.get_node(soundname).stop()
	else:
		print("stopsound: Sound " + soundname + " does not exist!")
		
func soundplaying(soundname):
	if GameNode.get_node_or_null(soundname) != null:
		if GameNode.get_node_or_null(soundname).playing:
			return true
		else:
			return false
	else:
		return false
	
func get_player():
	var PlayerNode = GameNode.get_node(@"obj_player")
	return PlayerNode
	
func get_level():
	var LevelNode = GameNode.get_node(@"level")
	return LevelNode
	
func room_goto(levelname, roomname):
	var oldlevel = get_level()
	var newroom = "res://Rooms/" + levelname + "/" + roomname + ".tscn"
	var newroomnode = load(newroom)
	var newroominstance = newroomnode.instance()
	global.targetRoom = roomname
	global.targetLevel = levelname
	oldlevel.queue_free()
	yield(get_tree().create_timer(0.01), "timeout")
	newroominstance.name = "level"
	GameNode.add_child(newroominstance)
	utils.get_instance("obj_music").room_start()
	
func savescore(levelname):
	if (global.collect > global.srank):
		global.rank = "s"
		utils.playsound("RankS")
	elif (global.collect > global.arank):
		global.rank = "a"
		utils.playsound("RankA")
	elif (global.collect > global.brank):
		global.rank = "b"
		utils.playsound("RankC")
	elif (global.collect > global.crank):
		global.rank = "c"
		utils.playsound("RankC")
	else:
		global.rank = "d"
		utils.playsound("RankD")
	var SaveManager = ConfigFile.new()
	var SaveData = SaveManager.load("user://saveData.ini")
	if (SaveManager.get_value("Highscore", levelname, 0) < global.collect):
		SaveManager.set_value("Highscore", levelname, global.collect)
	if (SaveManager.get_value("Treasure", levelname, false) == false):
		SaveManager.set_value("Treasure", levelname, global.treasure)
	if (SaveManager.get_value("Secret", levelname, 0) < global.secretfound):
		SaveManager.set_value("Secret", levelname, global.secretfound)
	if (SaveManager.get_value("Toppin", (levelname + "1"), false) == false):
		SaveManager.set_value("Toppin", (levelname + "1"), global.shroomfollow)
	if (SaveManager.get_value("Toppin", (levelname + "2"), false) == false):
		SaveManager.set_value("Toppin", (levelname + "2"), global.cheesefollow)
	if (SaveManager.get_value("Toppin", (levelname + "3"), false) == false):
		SaveManager.set_value("Toppin", (levelname + "3"), global.tomatofollow)
	if (SaveManager.get_value("Toppin", (levelname + "4"), false) == false):
		SaveManager.set_value("Toppin", (levelname + "4"), global.sausagefollow)
	if (SaveManager.get_value("Toppin", (levelname + "5"), false) == false):
		SaveManager.set_value("Toppin", (levelname + "5"), global.pineapplefollow)
	SaveManager.set_value("Ranks", levelname, global.rank)
	SaveManager.save("user://saveData.ini")
