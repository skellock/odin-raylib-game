#+feature using-stmt
package tests

import main "../src"
import "core:testing"

@(test)
init_clock_test :: proc(t: ^testing.T) {
	using main
	clock := init_clock()
	testing.expect_value(t, clock.elapsed, f64(0.0))
}

@(test)
format_clock_under_one_minute_test :: proc(t: ^testing.T) {
	using main
	buf: [32]byte
	result := format_clock_elapsed(45.9, buf[:])
	testing.expect_value(t, result, "45.9")
}

@(test)
format_clock_one_minute_test :: proc(t: ^testing.T) {
	using main
	buf: [32]byte
	result := format_clock_elapsed(90.0, buf[:])
	testing.expect_value(t, result, "1:30.0")
}

@(test)
format_clock_pads_seconds_test :: proc(t: ^testing.T) {
	using main
	buf: [32]byte
	result := format_clock_elapsed(65.0, buf[:])
	testing.expect_value(t, result, "1:05.0") // minutes > 0, seconds still padded
}

@(test)
format_clock_one_hour_test :: proc(t: ^testing.T) {
	using main
	buf: [32]byte
	result := format_clock_elapsed(3661.0, buf[:])
	testing.expect_value(t, result, "1:01:01.0")
}

@(test)
format_clock_pads_minutes_and_seconds_test :: proc(t: ^testing.T) {
	using main
	buf: [32]byte
	result := format_clock_elapsed(7384.0, buf[:])
	// 7384s = 2h 3m 4s
	testing.expect_value(t, result, "2:03:04.0")
}

@(test)
format_clock_millis_test :: proc(t: ^testing.T) {
	using main
	buf: [32]byte
	result := format_clock_elapsed(1.042, buf[:])
	testing.expect_value(t, result, "1.0")
}

@(test)
format_clock_pads_millis_test :: proc(t: ^testing.T) {
	using main
	buf: [32]byte
	result := format_clock_elapsed(0.007, buf[:])
	testing.expect_value(t, result, "0.0")
}
