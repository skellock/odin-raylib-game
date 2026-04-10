#+feature using-stmt
package tests

import main "../src"
import "core:testing"

@(test)
init_timer_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0)
	testing.expect_value(t, timer.duration, f32(1.0))
	testing.expect_value(t, timer.elapsed, f32(0.0))
	testing.expect_value(t, timer.active, false)
	testing.expect_value(t, timer.one_shot, false)
}

@(test)
init_timer_one_shot_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(2.0, one_shot = true)
	testing.expect_value(t, timer.one_shot, true)
}

@(test)
update_inactive_timer_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0)
	update_timer(&timer, 0.5)
	testing.expect_value(t, timer.elapsed, f32(0.0))
}

@(test)
update_active_timer_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0)
	timer.active = true
	update_timer(&timer, 0.3)
	testing.expect_value(t, timer.elapsed, f32(0.3))
	testing.expect_value(t, timer.active, true)
}

@(test)
one_shot_stops_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0, one_shot = true)
	timer.active = true
	update_timer(&timer, 1.5)
	testing.expect_value(t, timer.active, false)
	testing.expect_value(t, timer.elapsed, f32(1.0))
}

@(test)
multi_wraps_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0)
	timer.active = true
	update_timer(&timer, 1.3)
	testing.expect_value(t, timer.active, true)
	testing.expect(t, timer.elapsed > 0.29 && timer.elapsed < 0.31, "expected elapsed ~0.3")
}

@(test)
destroy_timer_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0)
	timer.active = true
	timer.elapsed = 0.5
	destroy_timer(&timer)
	testing.expect_value(t, timer.active, false)
	testing.expect_value(t, timer.elapsed, f32(0.0))
}

@(test)
paused_timer_does_not_update_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0)
	timer.active = true
	timer.paused = true
	update_timer(&timer, 0.5)
	testing.expect_value(t, timer.elapsed, f32(0.0))
}

@(test)
unpaused_timer_resumes_test :: proc(t: ^testing.T) {
	using main
	timer := init_timer(1.0)
	timer.active = true
	timer.paused = true
	update_timer(&timer, 0.5)
	testing.expect_value(t, timer.elapsed, f32(0.0))

	timer.paused = false
	update_timer(&timer, 0.3)
	testing.expect_value(t, timer.elapsed, f32(0.3))
}
