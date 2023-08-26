extends Area2D

@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHItBoxTimer

func tempdisable():
	print("tempdisable")
	collision.call_deferred("set", "disable", true)
	disableTimer.start()


func _on_disable_h_it_box_timer_timeout():
	print("enable hitbox")
	collision.call_deferred("set", "disable", false)
