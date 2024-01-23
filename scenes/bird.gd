extends RigidBody2D

@onready var animation = $AnimatedSprite2D
@onready var wing = $wing
@onready var smoosh = $smoosh
@onready var point = $point
@onready var hit = $hit


signal end_game()
signal score_entered()

var dead: bool = false
var click: float = .2

func _ready():
	smoosh.play()
	contact_monitor = true
	max_contacts_reported = 1
	
func _process(delta):
	if linear_velocity.y > 0 and click < 0:
		animation.rotation_degrees = 30
	click -= delta
		

func _input(_event):
	if not dead and Input.is_action_just_pressed("fly"):
		apply_impulse(Vector2(0, -500))
		animation.rotation_degrees = -30
		click = .25
		wing.play()

func _on_body_entered(body):
	if not dead and not body.is_in_group("good"):
		apply_impulse(Vector2(0, -200))
		apply_torque_impulse(-300)
		animation.stop()
		dead = true
		hit.play()
		end_game.emit()

func _on_area_2d_area_entered(area):
	if not dead and area.is_in_group("score_area"):
		point.play()
		score_entered.emit()
