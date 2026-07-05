package main

import rl "vendor:raylib"

RESHUFFLE_COOLDOWN :: f32(1.0)

Reshuffler :: struct {
	cooldown:  Timer,
	mouse_pos: rl.Vector2,
}

reshuffler_init :: proc() -> Reshuffler {
	return Reshuffler{cooldown = timer_init(RESHUFFLE_COOLDOWN, one_shot = true)}
}

reshuffler_update :: proc(game: ^Game, mouse: Mouse) {
	timer_update(&game.reshuffler.cooldown, rl.GetFrameTime())
	game.reshuffler.mouse_pos = mouse.world_pos

	if game.actions.reshuffle {
		deck_shuffle(&game.deck)
		game_deal_to_hand(game)
		timer_start(&game.reshuffler.cooldown)
	}
}

reshuffler_draw :: proc(self: Reshuffler) {
	if !self.cooldown.active { return }

	RADIUS :: f32(16)
	OFFSET_Y :: f32(-6)
	SEGMENTS :: 36
	BG_COLOR := rl.ColorAlpha(rl.BLACK, 0.3)
	FG_COLOR := rl.WHITE

	cx := self.mouse_pos.x
	cy := self.mouse_pos.y + OFFSET_Y

	// elapsed fraction (0.0 = start, 1.0 = done)
	fraction := self.cooldown.elapsed / self.cooldown.duration

	// background circle
	rl.DrawCircleV({cx, cy}, RADIUS, BG_COLOR)

	// pie slice filling up as cooldown progresses
	start_angle := f32(-90)
	end_angle := start_angle + fraction * 360
	rl.DrawCircleSector({cx, cy}, RADIUS, start_angle, end_angle, SEGMENTS, FG_COLOR)

	// border
	rl.DrawCircleLinesV({cx, cy}, RADIUS, rl.WHITE)
}

reshuffler_destroy :: proc(reshuffler: ^Reshuffler) {
	timer_destroy(&reshuffler.cooldown)
}
