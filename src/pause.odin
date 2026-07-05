package main

import "core:math"
import rl "vendor:raylib"

pause_draw :: proc() {
	// desaturate overlay
	rl.DrawRectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, rl.ColorAlpha(rl.BLACK, 0.6))

	// blinking "Paused" text
	FONT_SIZE :: f32(80)
	SPACING :: f32(2)
	BLINK_SPEED :: 3.0

	font := assets.fonts.body
	alpha := f32(0.5 + 0.5 * math.sin(f32(rl.GetTime()) * BLINK_SPEED))
	text :: "Paused"
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, SPACING)

	x := f32(GAME_WIDTH) / 2 - text_size.x / 2
	y := f32(GAME_HEIGHT) / 2 - text_size.y / 2

	rl.DrawTextEx(font, text, {x, y}, FONT_SIZE, SPACING, rl.ColorAlpha(rl.WHITE, alpha))
}
