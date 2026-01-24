extends Control

signal press_return

func _on_Return_pressed():
	emit_signal("press_return")

func show():
	.show()
	$ReturnTimer.start()

func _on_ReturnTimer_timeout():
	emit_signal("press_return")
