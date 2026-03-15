package main

import "core:fmt"
import rl "vendor:raylib"

// Draws an FPS thingy.
draw_debug :: proc(input: Input) {
	FONT_SIZE :: 16
	FONT_SPACING :: 2
	H_MARGIN :: 4
	V_MARGIN :: 4
	BG_COLOR: rl.Color : {0, 0, 0, 128}
	TEXT_COLOR :: rl.WHITE

	// what to print
	fps := rl.GetFPS()
	text := fmt.ctprintf("FPS: %d", fps)

	// calculate locations
	font := assets.fonts.body
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, FONT_SPACING)
	tw := i32(text_size.x)
	th := i32(text_size.y)
	tx: i32 = input.viewport.width - H_MARGIN * 2 - tw
	ty: i32 = V_MARGIN

	// draw
	rl.DrawRectangle(tx - H_MARGIN, ty - V_MARGIN, tw + H_MARGIN * 4, th + V_MARGIN * 2, BG_COLOR)
	rl.DrawTextEx(font, text, {f32(tx), f32(ty)}, FONT_SIZE, FONT_SPACING, TEXT_COLOR)
}
