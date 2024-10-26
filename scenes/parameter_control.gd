class_name PropertyControl extends VBoxContainer

@export var parameterName: String
@export var units: String
@export var minimum: float
@export var maximum: float
@export_category("Public Node Properties")
@export var value: float

@onready var parameterLabel: Label = $HBoxContainer/Label
@onready var valueLabel: Label = $HBoxContainer/value
@onready var slider: HSlider = $HSlider

func _ready() -> void:
	parameterLabel.text = parameterName
	valueLabel.text = value_label_text(slider.value)
	slider.min_value = minimum
	slider.max_value = maximum
	pass

func _on_h_slider_value_changed(value: float) -> void:
	self.value = value;
	valueLabel.text = value_label_text(value)

func value_label_text(value: float) -> String:
	return str(value) + " " + units
