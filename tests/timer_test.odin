#+feature using-stmt
package tests

import main "../src"
import "core:testing"

@(test)
timer_init_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0)
	testing.expect_value(t, timer.duration, f32(1.0))
	testing.expect_value(t, timer.elapsed, f32(0.0))
	testing.expect_value(t, timer.active, false)
	testing.expect_value(t, timer.one_shot, false)
}

@(test)
timer_init_one_shot_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(2.0, one_shot = true)
	testing.expect_value(t, timer.one_shot, true)
}

@(test)
timer_update_inactive_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0)
	timer_update(&timer, 0.5)
	testing.expect_value(t, timer.elapsed, f32(0.0))
}

@(test)
timer_update_active_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0)
	timer.active = true
	timer_update(&timer, 0.3)
	testing.expect_value(t, timer.elapsed, f32(0.3))
	testing.expect_value(t, timer.active, true)
}

@(test)
timer_update_one_shot_stops_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0, one_shot = true)
	timer.active = true
	timer_update(&timer, 1.5)
	testing.expect_value(t, timer.active, false)
	testing.expect_value(t, timer.elapsed, f32(1.0))
}

@(test)
timer_update_multi_wraps_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0)
	timer.active = true
	timer_update(&timer, 1.3)
	testing.expect_value(t, timer.active, true)
	testing.expect(t, timer.elapsed > 0.29 && timer.elapsed < 0.31, "expected elapsed ~0.3")
}

@(test)
timer_destroy_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0)
	timer.active = true
	timer.elapsed = 0.5
	timer_destroy(&timer)
	testing.expect_value(t, timer.active, false)
	testing.expect_value(t, timer.elapsed, f32(0.0))
}

@(test)
timer_update_pause_does_not_update_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0)
	timer.active = true
	timer.paused = true
	timer_update(&timer, 0.5)
	testing.expect_value(t, timer.elapsed, f32(0.0))
}

@(test)
timer_update_unpause_resumes_test :: proc(t: ^testing.T) {
	using main
	timer := timer_init(1.0)
	timer.active = true
	timer.paused = true
	timer_update(&timer, 0.5)
	testing.expect_value(t, timer.elapsed, f32(0.0))

	timer.paused = false
	timer_update(&timer, 0.3)
	testing.expect_value(t, timer.elapsed, f32(0.3))
}
