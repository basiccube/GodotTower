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
	
func get_player():
	var GameNode = get_node(@"/root/Game")
	var PlayerNode = GameNode.get_node(@"obj_player")
	return PlayerNode
