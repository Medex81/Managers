# Менеджер общих вспомогательных методов
extends Node

enum {
	FORMAT_HOURS   = 0x2,
	FORMAT_MINUTES = 0x4,
	FORMAT_SECONDS = 0x8,
	FORMAT_DEFAULT = 0x2 | 0x4 | 0x8
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func format_timestamp_to_str(time, format = FORMAT_DEFAULT, digit_format = "%02d"):
	var digits = []

	if format & FORMAT_HOURS:
		var hours = digit_format % [time / 3600]
		digits.append(hours)

	if format & FORMAT_MINUTES:
		var minutes = digit_format % [time / 60]
		digits.append(minutes)

	if format & FORMAT_SECONDS:
		var seconds = digit_format % [int(ceil(time)) % 60]
		digits.append(seconds)

	var formatted = String()
	var colon = " : "

	for idx in digits.size():
		formatted += digits[idx]
		if idx != digits.size() - 1:
			formatted += colon

	return formatted
