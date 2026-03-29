package main

import "core:math"
import rl "vendor:raylib"

update_pause :: proc(game: ^Game) {
	if game.actions.toggle_pause {
		game.paused = !game.paused
	}
}

draw_pause :: proc(game: ^Game) {
	if !game.paused do return

	vw := game.input.viewport.width
	vh := game.input.viewport.height

	// desaturate overlay
	rl.DrawRectangle(0, 0, vw, vh, rl.ColorAlpha(rl.BLACK, 0.6))

	// blinking "Paused" text
	FONT_SIZE :: f32(80)
	SPACING :: f32(2)
	BLINK_SPEED :: 3.0

	font := assets.fonts.body
	alpha := f32(0.5 + 0.5 * math.sin(f32(game.time.elapsed) * BLINK_SPEED))
	text :: "Paused"
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, SPACING)

	x := f32(vw) / 2 - text_size.x / 2
	y := f32(vh) / 2 - text_size.y / 2

	rl.DrawTextEx(font, text, {x, y}, FONT_SIZE, SPACING, rl.ColorAlpha(rl.WHITE, alpha))
}
