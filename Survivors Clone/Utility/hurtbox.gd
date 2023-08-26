extends Area2D

@export_enum("Cooldonw", "HitOnce", "DisableHitbox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

var hit_process = false
var damage_const = 0

signal hurt(damage)

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #CoolDown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: #HitOnce
					pass
				2: #DisableHitbox
					if area.has_method("tempdisable"):
						area.tempdisable()
			emit_signal("hurt", area.damage)

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
