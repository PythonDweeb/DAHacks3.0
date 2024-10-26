extends RigidBody2D

@export var planet: StaticBody2D
@export var launchButton: Button

@export var fuelControl: PropertyControl
@export var exitVelocityControl: PropertyControl
@export var angleControl: PropertyControl # in degrees

signal rocket_launched

var launched: bool = false

#const gravity: float = 9.8
const bigG: float = 0.0000000000667
const planetMass: int = 5972200000000000000 # kg * e-5
const baseRocketMass: float = 28.11641294  # kg * e-5
const fuelDensity: float = 0.0000000083 # g * e-5

func _ready() -> void:
	launchButton.pressed.connect(_launchButton_pressed)

func _physics_process(delta: float) -> void:
	apply_planet_gravity()
	
	if launched: apply_rocket_velocity()

func apply_planet_gravity() -> void:
	var direction: float = get_angle_to(planet.global_position)
	var vector: Vector2 = get_relative_vector(direction)
	var distance: float = self.global_position.distance_to(planet.global_position) * 50
	
	print(distance, " ", planetMass, " ", bigG)
	
	var totalRocketMass: float = baseRocketMass + get_fuel_mass()
	
	var force: float = (bigG * planetMass * totalRocketMass) / (distance ** 2)
	var acceleration: float = force / totalRocketMass
	print(acceleration)
	self.apply_force(vector * acceleration)

func get_fuel_mass() -> float:
	return fuelDensity * fuelControl.value

func apply_rocket_velocity() -> void:
	var vector: Vector2 = get_relative_vector(-(PI / 2)) # 90 degrees
	self.apply_central_force(vector * (exitVelocityControl.value / 100))
	pass
	
func get_relative_vector(rotation: float) -> Vector2:
	var angle = rotation + self.rotation
	return Vector2(cos(angle), sin(angle))

func _launchButton_pressed() -> void:
	launched = true
	rocket_launched.emit()
