extends HBoxContainer


var resources: Array = [
	preload("res://assets/UI/Numbers/0.png"),
	preload("res://assets/UI/Numbers/1.png"),
	preload("res://assets/UI/Numbers/2.png"),
	preload("res://assets/UI/Numbers/3.png"),
	preload("res://assets/UI/Numbers/4.png"),
	preload("res://assets/UI/Numbers/5.png"),
	preload("res://assets/UI/Numbers/6.png"),
	preload("res://assets/UI/Numbers/7.png"),
	preload("res://assets/UI/Numbers/8.png"),
	preload("res://assets/UI/Numbers/9.png"),
]

func _ready():
	set_score(0)


func set_score(num: int):
	for node in get_children():
		remove_child(node)
	
	for n in str(num):
		var t = TextureRect.new()
		t.texture = resources[int(n)]
		add_child(t)
