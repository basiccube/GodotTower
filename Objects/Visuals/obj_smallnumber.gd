extends Node2D

var number = "1"

func _ready():
	$DestroyTimer.start()
	
func _process(delta):
	$Number.text = number

func _on_DestroyTimer_timeout():
	queue_free()
