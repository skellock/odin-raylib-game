package main

Timer :: struct {
	elapsed:  f32,
	duration: f32,
	active:   bool,
	paused:   bool,
	one_shot: bool,
}

timer_init :: proc(duration: f32, one_shot := false) -> Timer {
	return Timer{duration = duration, one_shot = one_shot}
}

timer_start :: proc(timer: ^Timer) {
	timer.elapsed = 0
	timer.active = true
}

timer_update :: proc(timer: ^Timer, dt: f32) {
	if !timer.active { return }
	if timer.paused { return }
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

timer_destroy :: proc(timer: ^Timer) {
	timer.active = false
	timer.elapsed = 0
}
