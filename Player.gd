extends RigidBody3D

var speed := 2400.0
var jump_height := 50000.0

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	contact_monitor = true
	max_contacts_reported = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("left", "right") 
	input.z = Input.get_axis("forward", "back")
	
	apply_central_force($TwistPivot.basis * input * speed * delta)
	if Input.is_action_just_pressed("jump"):
		if get_contact_count() > 0:
			apply_central_force(Vector3.UP * jump_height * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	$TwistPivot.rotate_y(twist_input)
	$Body.rotate_y(twist_input)
	$TwistPivot/PitchPivot.rotate_x(pitch_input)
	$TwistPivot/PitchPivot.rotation.x = clamp($TwistPivot/PitchPivot.rotation.x, 
		deg_to_rad(-50), 
		deg_to_rad(50)
	)
	
	twist_input = 0.0
	pitch_input = 0.0

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
			
