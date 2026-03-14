package main

Timer :: struct {
	elapsed:  f32,
	duration: f32,
	active:   bool,
	one_shot: bool,
}

init_timer :: proc(duration: f32, one_shot := false) -> Timer {
	return Timer{duration = duration, one_shot = one_shot}
}

start_timer :: proc(timer: ^Timer) {
	timer.elapsed = 0
	timer.active = true
}

update_timer :: proc(timer: ^Timer, dt: f32) {
	if !timer.active do return
	timer.elapsed += dt
	if timer.elapsed >= timer.duration {
		if timer.one_shot {
			timer.active = false
			timer.elapsed = timer.duration
		} else {
			timer.elapsed -= timer.duration
		}
	}
}

destroy_timer :: proc(timer: ^Timer) {
	timer.active = false
	timer.elapsed = 0
}
