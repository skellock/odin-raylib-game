#+feature using-stmt
package tests

import main "../src"
import "core:testing"

@(test)
reshuffler_init_test :: proc(t: ^testing.T) {
	using main, testing

	reshuffler := reshuffler_init()
	defer reshuffler_destroy(&reshuffler)

	expect_value(t, reshuffler.cooldown.duration, RESHUFFLE_COOLDOWN)
	expect_value(t, reshuffler.cooldown.one_shot, true)
	expect_value(t, reshuffler.cooldown.active, false)
}

@(test)
reshuffler_cooldown_test :: proc(t: ^testing.T) {
	using main, testing

	reshuffler := reshuffler_init()
	defer reshuffler_destroy(&reshuffler)

	// start the cooldown as if a reshuffle just happened
	timer_start(&reshuffler.cooldown)
	expect_value(t, reshuffler.cooldown.active, true)

	// after partial time, still active
	timer_update(&reshuffler.cooldown, RESHUFFLE_COOLDOWN * 0.5)
	expect_value(t, reshuffler.cooldown.active, true)

	// after full duration, cooldown expires
	timer_update(&reshuffler.cooldown, RESHUFFLE_COOLDOWN * 1.5)
	expect_value(t, reshuffler.cooldown.active, false)
}

@(test)
reshuffler_cooldown_resets_test :: proc(t: ^testing.T) {
	using main, testing

	reshuffler := reshuffler_init()
	defer reshuffler_destroy(&reshuffler)

	// first cooldown cycle
	timer_start(&reshuffler.cooldown)
	timer_update(&reshuffler.cooldown, RESHUFFLE_COOLDOWN)
	expect_value(t, reshuffler.cooldown.active, false)

	// can start again
	timer_start(&reshuffler.cooldown)
	expect_value(t, reshuffler.cooldown.active, true)
	expect_value(t, reshuffler.cooldown.elapsed, 0)
}
