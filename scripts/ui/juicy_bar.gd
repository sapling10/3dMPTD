extends Control
class_name JuicyBar

@export var top_layer_bar: ProgressBar
@export var middle_layer_bar: ProgressBar
@export var bottom_layer_bar: ProgressBar

@export var min_val: float
@export var max_val: float
@export var current_val: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_val = max_val
	set_progress_bar_def_vals(top_layer_bar)
	set_progress_bar_def_vals(middle_layer_bar)
	set_progress_bar_def_vals(bottom_layer_bar)

func set_progress_bar_def_vals(bar: ProgressBar):
	bar.min_value = min_val
	bar.max_value = max_val
	bar.value = current_val

func change_current_val(value: float):
	current_val = clamp(value, min_val, max_val)
	run_juicy_tween(top_layer_bar, value, 0.2, 0.05) # or (0.2, 0)
	run_juicy_tween(middle_layer_bar, value, 0.05, 0)
	run_juicy_tween(bottom_layer_bar, value, 0.35, 0.1)

func run_juicy_tween(bar: ProgressBar, value: float, length: float, delay: float):
	var tween = create_tween()
	tween.tween_property(bar, "value", value, length).set_delay(delay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_set_health(_health: float) -> void:
	change_current_val(_health)
