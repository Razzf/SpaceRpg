extends Node2D


onready var richtext = $Panel/RichTextLabel


var dialog = [
	"Hi!, im the AI unit asigned to you in this travel.",
	"I'm here to guide you through your space travel."]
var page = 0

# Functions
func _ready():
	$AnimationPlayer.play("panelappear")
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("Idle")
	set_process_input(true)
	richtext.set_bbcode(dialog[page])
	richtext.set_visible_characters(0)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if richtext.get_visible_characters() > richtext.get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				richtext.set_bbcode(dialog[page])
				richtext.set_visible_characters(0)
		else:
			richtext.set_visible_characters(richtext.get_total_character_count())

func _on_Timer_timeout():
	richtext.set_visible_characters(richtext.get_visible_characters()+1)
