package main

import rl "vendor:raylib"

RESHUFFLE_COOLDOWN :: f32(1.0)

Reshuffler :: struct {
	cooldown: Timer,
}

init_reshuffler :: proc() -> Reshuffler {
	return Reshuffler{cooldown = init_timer(RESHUFFLE_COOLDOWN, one_shot = true)}
}

update_reshuffler :: proc(game: ^Game) {
	update_timer(&game.reshuffler.cooldown, game.time.dt)

	if game.actions.reshuffle {
		shuffle_deck(&game.deck)
		deal_to_hand(game)
		start_timer(&game.reshuffler.cooldown)
	}
}

draw_reshuffler :: proc(game: ^Game) {
	cooldown := game.reshuffler.cooldown
	if !cooldown.active do return

	RADIUS :: f32(16)
	OFFSET_Y :: f32(-6)
	SEGMENTS :: 36
	BG_COLOR := rl.ColorAlpha(rl.BLACK, 0.3)
	FG_COLOR := rl.WHITE

	cx := game.mouse.world_pos.x
	cy := game.mouse.world_pos.y + OFFSET_Y

	// elapsed fraction (0.0 = start, 1.0 = done)
	fraction := cooldown.elapsed / cooldown.duration

	// background circle
	rl.DrawCircleV({cx, cy}, RADIUS, BG_COLOR)

	// pie slice filling up as cooldown progresses
	start_angle := f32(-90)
	end_angle := start_angle + fraction * 360
	rl.DrawCircleSector({cx, cy}, RADIUS, start_angle, end_angle, SEGMENTS, FG_COLOR)

	// border
	rl.DrawCircleLinesV({cx, cy}, RADIUS, rl.WHITE)
}

destroy_reshuffler :: proc(reshuffler: ^Reshuffler) {
	destroy_timer(&reshuffler.cooldown)
}
