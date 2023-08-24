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
	
func instance_exists(node):
	var instancenode = GameNode.get_node(node)
	if instancenode == null:
		return false
	else:
		return true
		
func get_instance(node):
	var instancenode = GameNode.get_node(node)
	return instancenode
	
func get_gamenode():
	return GameNode
	
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
