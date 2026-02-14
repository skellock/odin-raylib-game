package main

import "core:fmt"
import rl "vendor:raylib"

// Draws an FPS thingy.
draw_debug :: proc(input: ^Input) {
	FONT_SIZE :: 10
	FONT_SPACING :: 1
	H_MARGIN :: 8
	V_MARGIN :: 4
	BG_COLOR: rl.Color : {0, 0, 0, 128}
	TEXT_COLOR :: rl.WHITE

	// what to print
	fps := rl.GetFPS()
	text := fmt.ctprintf("FPS: %d", fps)

	// calculate locations
	font := rl.GetFontDefault()
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, FONT_SPACING)
	tw := i32(text_size.x)
	th := i32(text_size.y)
	tx: i32 = input.screen_width - H_MARGIN - tw
	ty: i32 = V_MARGIN

	// draw
	rl.DrawRectangle(tx - H_MARGIN, ty - V_MARGIN, tw + H_MARGIN * 2, th + V_MARGIN * 2, BG_COLOR)
	rl.DrawText(text, tx, ty, FONT_SIZE, TEXT_COLOR)
}
