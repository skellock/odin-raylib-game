package main

import "core:testing"

@(test)
init_reshuffler_test :: proc(t: ^testing.T) {
	reshuffler := init_reshuffler()
	defer destroy_reshuffler(&reshuffler)

	testing.expect_value(t, reshuffler.cooldown.duration, RESHUFFLE_COOLDOWN)
	testing.expect_value(t, reshuffler.cooldown.one_shot, true)
	testing.expect_value(t, reshuffler.cooldown.active, false)
}

@(test)
reshuffler_cooldown_blocks_test :: proc(t: ^testing.T) {
	reshuffler := init_reshuffler()
	defer destroy_reshuffler(&reshuffler)

	// start the cooldown as if a reshuffle just happened
	start_timer(&reshuffler.cooldown)
	testing.expect_value(t, reshuffler.cooldown.active, true)

	// after partial time, still active
	update_timer(&reshuffler.cooldown, 1.0)
	testing.expect_value(t, reshuffler.cooldown.active, true)

	// after full duration, cooldown expires
	update_timer(&reshuffler.cooldown, 2.0)
	testing.expect_value(t, reshuffler.cooldown.active, false)
}

@(test)
reshuffler_cooldown_resets_test :: proc(t: ^testing.T) {
	reshuffler := init_reshuffler()
	defer destroy_reshuffler(&reshuffler)

	// first cooldown cycle
	start_timer(&reshuffler.cooldown)
	update_timer(&reshuffler.cooldown, 3.0)
	testing.expect_value(t, reshuffler.cooldown.active, false)

	// can start again
	start_timer(&reshuffler.cooldown)
	testing.expect_value(t, reshuffler.cooldown.active, true)
	testing.expect_value(t, reshuffler.cooldown.elapsed, f32(0.0))
}
