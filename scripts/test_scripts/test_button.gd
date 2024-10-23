extends Button

@export var juicy_bar: JuicyBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	if name == "TestButton":
		juicy_bar.change_current_val(juicy_bar.current_val - 10)
	else:
		juicy_bar.change_current_val(juicy_bar.current_val + 10)	
