package main

import rl "vendor:raylib"

RESHUFFLE_COOLDOWN :: f32(1.0)

Reshuffler :: struct {
	cooldown: Timer,
}

init_reshuffler :: proc() -> Reshuffler {
	return Reshuffler{cooldown = init_timer(RESHUFFLE_COOLDOWN, one_shot = true)}
}

update_reshuffler :: proc(game: ^Game, input: Input) {
	update_timer(&game.reshuffler.cooldown, input.time.dt)

	if input.mouse.right_pressed && !game.reshuffler.cooldown.active {
		shuffle_deck(&game.deck)
		deal_to_hand(game)
		start_timer(&game.reshuffler.cooldown)
	}
}

draw_reshuffler :: proc(game: Game, input: Input) {
	cooldown := game.reshuffler.cooldown
	if !cooldown.active do return

	RADIUS :: f32(8)
	OFFSET_Y :: f32(16)
	SEGMENTS :: 36
	BG_COLOR := rl.ColorAlpha(rl.BLACK, 0.3)
	FG_COLOR := rl.WHITE

	cx := f32(input.mouse.world_x)
	cy := f32(input.mouse.world_y) + OFFSET_Y

	// elapsed fraction (0.0 = start, 1.0 = done)
	fraction := cooldown.elapsed / cooldown.duration

	// background circle
	rl.DrawCircleV({cx, cy}, RADIUS, BG_COLOR)

	// pie slice filling up as cooldown progresses
	start_angle := f32(-90)
	end_angle := start_angle + fraction * 360
	rl.DrawCircleSector({cx, cy}, RADIUS, start_angle, end_angle, SEGMENTS, FG_COLOR)
}

destroy_reshuffler :: proc(reshuffler: ^Reshuffler) {
	destroy_timer(&reshuffler.cooldown)
}
