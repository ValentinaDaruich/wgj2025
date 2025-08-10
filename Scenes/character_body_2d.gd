extends CharacterBody2D

@export var move_speed: float = 300.0
@onready var navigation_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	navigation_agent.path_desired_distance = 10.0
	navigation_agent.target_desired_distance = 10.0
	animated_sprite.play("idle")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		navigation_agent.target_position = get_global_mouse_position()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		velocity = Vector2.ZERO
		return
	
	var next_path_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	update_animation(direction)
	
	velocity = direction * move_speed
	move_and_slide()

func update_animation(direction: Vector2):
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	if animated_sprite.animation != "walk" and velocity.length() > 0:
		animated_sprite.play("walk")
	elif velocity.length() == 0 and animated_sprite.animation != "idle":
		animated_sprite.play("idle")
