#+feature using-stmt
package tests

import main "../src"
import "core:testing"

@(test)
clock_init_test :: proc(t: ^testing.T) {
	using main, testing

	clock := clock_init()
	expect_value(t, clock.elapsed, f64(0.0))
}

@(test)
clock_format_under_one_minute_test :: proc(t: ^testing.T) {
	using main, testing

	buf: [32]byte
	result := clock_format_elapsed(45.9, buf[:])
	expect_value(t, result, "45.9")
}

@(test)
clock_format_one_minute_test :: proc(t: ^testing.T) {
	using main, testing

	buf: [32]byte
	result := clock_format_elapsed(90.0, buf[:])
	expect_value(t, result, "1:30.0")
}

@(test)
clock_format_pads_seconds_test :: proc(t: ^testing.T) {
	using main, testing

	buf: [32]byte
	result := clock_format_elapsed(65.0, buf[:])
	expect_value(t, result, "1:05.0") // minutes > 0, seconds still padded
}

@(test)
clock_format_one_hour_test :: proc(t: ^testing.T) {
	using main, testing

	buf: [32]byte
	result := clock_format_elapsed(3661.0, buf[:])
	expect_value(t, result, "1:01:01.0")
}

@(test)
clock_format_pads_minutes_and_seconds_test :: proc(t: ^testing.T) {
	using main, testing

	buf: [32]byte
	result := clock_format_elapsed(7384.0, buf[:])
	expect_value(t, result, "2:03:04.0")
}

@(test)
clock_format_millis_test :: proc(t: ^testing.T) {
	using main, testing

	buf: [32]byte
	result := clock_format_elapsed(1.042, buf[:])
	expect_value(t, result, "1.0")
}

@(test)
clock_format_pads_millis_test :: proc(t: ^testing.T) {
	using main, testing

	buf: [32]byte
	result := clock_format_elapsed(0.007, buf[:])
	expect_value(t, result, "0.0")
}
