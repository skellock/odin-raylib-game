package main

import "core:math"
import rl "vendor:raylib"

update_pause :: proc(game: ^Game, actions: Actions) {
	if actions.toggle_pause {
		game.paused = !game.paused
	}
}

draw_pause :: proc(game: Game, input: Input) {
	if !game.paused do return

	vw := input.viewport.width
	vh := input.viewport.height

	// desaturate overlay
	rl.DrawRectangle(0, 0, vw, vh, rl.ColorAlpha(rl.BLACK, 0.6))

	// blinking "Paused" text
	FONT_SIZE :: i32(40)
	BLINK_SPEED :: 3.0

	alpha := f32(0.5 + 0.5 * math.sin(f32(input.time.elapsed) * BLINK_SPEED))
	text :: "Paused"
	text_w := rl.MeasureText(text, FONT_SIZE)

	x := vw / 2 - text_w / 2
	y := vh / 2 - FONT_SIZE / 2

	rl.DrawText(text, x, y, FONT_SIZE, rl.ColorAlpha(rl.WHITE, alpha))
}
