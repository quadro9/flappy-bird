extends Node2D


@onready var parallax = $ParallaxBackground
@onready var game_over = $CanvasLayer/GameOver
@onready var start_game_text = $CanvasLayer/StartGame
@onready var bird_marker = $BirdMarker
@onready var new_game_timer = $NewGameTimer

@onready var pipes_layer = $ParallaxBackground/PipesLayer
@onready var pipe_marker = $PipeMarker
@onready var new_pipe_timer = $NewPipeTimer
@onready var score_label = $CanvasLayer/Score
@onready var record = $CanvasLayer/CenterContainer/Record

@onready var die = $die

const BIRD = preload("res://scenes/bird.tscn")
const PIPES = preload("res://scenes/pipes.tscn")

@export var max_speed = 100
var speed = max_speed

enum GameState {MENU, GAME, END, NEW}
var state: GameState = GameState.MENU

var score = 0
var max_score = 0

func _ready():
	game_over.visible = false
	start_game_text.visible = true
	score_label.visible = false


func _process(delta):
	if state == GameState.END or state == GameState.NEW:
		speed = move_toward(speed, 0, max_speed * delta)
	parallax.scroll_offset.x -= speed * delta

func _input(_event):
	if state == GameState.MENU and Input.is_action_just_pressed("fly"):
		start_game()
	
	if state == GameState.NEW and Input.is_action_just_pressed("fly"):
		new_game()

func _on_bird_end_game():
	state = GameState.END
	new_game_timer.start()
	new_pipe_timer.stop()
	
func _on_bird_score_entered():
	score += 1
	set_score(score)

func set_score(num: int):
	score = num
	score_label.set_score(score)
	max_score = max(max_score, score)
	record.set_score(max_score)

func start_game():
	state = GameState.GAME
	set_score(0)
	start_game_text.visible = false
	score_label.visible = true
	record.visible = false
	var bird := BIRD.instantiate()
	bird.end_game.connect(_on_bird_end_game)
	bird.score_entered.connect(_on_bird_score_entered)
	bird.position = bird_marker.position
	add_child(bird)
	new_pipe_timer.start()

func new_game():
	state = GameState.MENU
	game_over.visible = false
	start_game_text.visible = true
	score_label.visible = false
	record.visible = true
	speed = max_speed
	var nodes_to_delete = get_tree().get_nodes_in_group("player")
	for node in nodes_to_delete:
		remove_child(node)
		
	var pipes_to_delete = get_tree().get_nodes_in_group("pipes")
	for node in pipes_to_delete:
		pipes_layer.remove_child(node)

func _on_timer_timeout():
	state = GameState.NEW
	game_over.visible = true
	die.play()

func _on_new_pipe_timer_timeout():
	var pipe := PIPES.instantiate()
	pipes_layer.add_child(pipe)
	pipe.position.x = abs(pipes_layer.position.x) + pipe_marker.position.x
	pipe.position.y = randi_range(70, 340)
