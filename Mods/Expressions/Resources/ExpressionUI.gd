extends Control
class_name ExpressionUI

var ui_item : Dictionary = {}
var old_item : Dictionary = {}
var currently_setting : bool = false

signal on_change_item(action : int, item : Dictionary, old_item : Dictionary)

## Load the item to the UI elements.
## Keybind does not have to be set, but must be -1 if not set.
func set_item(item : Dictionary) -> void:
	# Bind to the UI item.
	ui_item = item

	var action : String = item["keybind_name"]
	#if item["key"] != -1:
		#_set_key_bind_display(item)

	%BlendShapeNameTxt.text = action
	# emit_signal("on_change_item", ChangeAction.INITIAL, item, {})

func _set_key_bind_display(item : Dictionary):
	var key_code : Key = item["key"]
	
	var input_event = InputEventKey.new()
	input_event.physical_keycode = key_code


	var display_bind = OS.get_keycode_string(
		DisplayServer.keyboard_get_label_from_physical(
			input_event.get_physical_keycode_with_modifiers()))
	print_debug(display_bind)
	%KeybindNameDisplay.text = display_bind

## Set the UI item to be blank.
func blank_item() -> void:
	ui_item = {
		"blendshape_name": "",
		"keybind_name": "",
		"slew_time": 1.0,
		"intensity": 1.0,
		"active": false
	}

func _on_blendshape_name_txt_text_changed(new_text : String) -> void:
	old_item = ui_item.duplicate()
	ui_item["blendshape_name"] = new_text
	emit_signal("on_change_item", ExpressionsChangeAction.BLENDSHAPE_NAME, ui_item, old_item)
	
func _on_keybind_name_display_text_changed(new_text : String) -> void:
	old_item = ui_item.duplicate()
	ui_item["keybind_name"] = new_text
	emit_signal("on_change_item", ExpressionsChangeAction.KEY_BIND, ui_item, old_item)

func _on_delete_btn_pressed() -> void:
	emit_signal("on_change_item", ExpressionsChangeAction.DELETE, ui_item, {})
	queue_free()

func _on_slew_time_slider_value_changed(value: float) -> void:
	%SlewTimeLabel.text = str(value)


func _on_intensity_slider_value_changed(value: float) -> void:
	%IntensityLabel.text = str(value)
