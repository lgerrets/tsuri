extends KinematicBody2D

const speed = 300

var velocity = Vector2(0, 0)
var player_idx = 0 # *local* player index (eg there may be 2 local players in the server app)

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_network_master():
		var x_input = 0
		var y_input = 0
		if player_idx == 0:
			x_input = int(Input.is_action_pressed("right_p1")) - int(Input.is_action_pressed("left_p1"))
			y_input = int(Input.is_action_pressed("down_p1")) - int(Input.is_action_pressed("up_p1"))
		elif player_idx == 1:
			x_input = int(Input.is_action_pressed("right_p2")) - int(Input.is_action_pressed("left_p2"))
			y_input = int(Input.is_action_pressed("down_p2")) - int(Input.is_action_pressed("up_p2"))
		else:
			assert(false)
			
		velocity = Vector2(x_input, y_input).normalized()
		
		move_and_slide(velocity * speed)

func puppet_position_set(new_value) -> void:
	# TODO: instead use a tween to interpolate to compensate for lag
	global_position = new_value

func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
