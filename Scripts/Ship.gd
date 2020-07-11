extends KinematicBody

var velocity = Vector3()
var base_speed = 500
var turn_speed = 600
var turn_rotation_speed = 3
var turn_rotation_max_angle = 20

var control_inputs = {
	"x" : 0.0,
	"y" : 0.0,
	"speed_boost" : 1.0
}

func _ready():
	pass

func _physics_process(delta):
	input()
	if abs(control_inputs["y"]) < 0.05:
		if abs(rotation_degrees.x) > 5:
			rotate(Vector3(1 ,0 ,0), -turn_rotation_speed * sign(rotation_degrees.x) * delta)
		else:
			rotation_degrees.x = 0
	else:
		rotate(Vector3(1 ,0 ,0), -turn_rotation_speed * control_inputs["y"] * delta)
		
	if abs(control_inputs["x"]) < 0.05:
		if abs(rotation_degrees.y) > 5:
			rotate(Vector3(0 ,1 ,0), -turn_rotation_speed * sign(rotation_degrees.y) * delta)
			rotate(Vector3(0 ,0 ,1), -turn_rotation_speed * sign(rotation_degrees.z) * delta)
		else:
			rotation_degrees.y = 0
			rotation_degrees.z = 0
	else:
		rotate(Vector3(0 ,1 ,0), turn_rotation_speed * control_inputs["x"] * delta)
		rotate(Vector3(0 ,0 ,1), -turn_rotation_speed * control_inputs["x"] * delta)
	print(rotation_degrees.z)
	rotation_degrees.x = clamp(rotation_degrees.x, -turn_rotation_max_angle, turn_rotation_max_angle)
	rotation_degrees.y = clamp(rotation_degrees.y, -turn_rotation_max_angle, turn_rotation_max_angle)
	rotation_degrees.z = clamp(rotation_degrees.z, -turn_rotation_max_angle, turn_rotation_max_angle)
	velocity = Vector3(0, 0, 0)
	velocity += Vector3(0, 0, 1) * base_speed * control_inputs["speed_boost"] * delta 
	velocity += control_inputs["x"] * Vector3(1, 0, 0) * turn_speed * control_inputs["speed_boost"] * delta
	velocity += control_inputs["y"] * Vector3(0, 1, 0) * turn_speed * control_inputs["speed_boost"] * delta
	velocity = move_and_slide(velocity, Vector3.UP)

func input():
	control_inputs["x"] = 0
	control_inputs["y"] = 0
	control_inputs["speed_boost"] = 1.0
	
	if Input.is_action_pressed("move_right"):
		control_inputs["x"] -= 1
	if Input.is_action_pressed("move_left"):
		control_inputs["x"] += 1
	if Input.is_action_pressed("move_up"):
		control_inputs["y"] += 1
	if Input.is_action_pressed("move_down"):
		control_inputs["y"] -= 1
	if Input.is_action_pressed("boost"):
		control_inputs["speed_boost"] = 2