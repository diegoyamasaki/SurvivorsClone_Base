extends CharacterBody2D

var movement_speed = 40.0
var hp = 80
var last_movement = Vector2.UP


#Attack
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javalin = preload("res://Player/Attack/javalin.tscn")

#AttackNode
@onready var iceSpearTimer:Timer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer:Timer = get_node("%IceSpearAttackTimer")

@onready var tornadoTimer:Timer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer:Timer = get_node("%TornadoAttackTimer")

@onready var javalintBase = get_node("%javalinBase")

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_attackspeed = 1.5
var icespear_level = 0

#Tornado
var tornado_ammo = 1
var tornado_baseammo = 1
var tornado_attackspeed = 3
var tornado_level = 1


#Tornado
var javalin_ammo = 1
var javalin_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("WalkTimer")

func _ready():
	attack()

func _physics_process(_delta):
	movement()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	var mov = Vector2(x_mov, y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame = 1
			walkTimer.start()
	velocity = mov.normalized() * movement_speed
	move_and_slide()

func _on_hurtbox_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	if javalin_level > 0:
		spam_javalin()


func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo
	iceSpearTimer.start()
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout():
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = sprite.position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo
	tornadoTimer.start()
	tornadoAttackTimer.start()


func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = sprite.position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()

func spam_javalin():
	var get_javalin_total = javalintBase.get_child_count()
	var calc_spams = javalin_ammo - get_javalin_total
	while calc_spams > 0:
		var javalin_spam = javalin.instantiate()
		javalin_spam.global_position = global_position
		javalintBase.add_child(javalin_spam)
		calc_spams -= 1
