package main

import "core:fmt"
import rl "vendor:raylib"

// Draws an FPS thingy.
debug_draw :: proc(game: ^Game) {
	FONT_SIZE :: 16
	FONT_SPACING :: 2
	H_MARGIN :: f32(4)
	V_MARGIN :: f32(4)
	BG_COLOR: rl.Color : {0, 0, 0, 128}
	TEXT_COLOR :: rl.WHITE

	// what to print
	fps := rl.GetFPS()
	text := fmt.ctprintf("FPS: %d", fps)

	// calculate locations
	font := assets.fonts.body
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, FONT_SPACING)
	tw := text_size.x
	th := text_size.y
	tx := f32(game.viewport.width) - H_MARGIN * 2 - tw
	ty := V_MARGIN
	box_rect := rl.Rectangle{tx - H_MARGIN, ty - V_MARGIN, tw + H_MARGIN * 4, th + V_MARGIN * 2}

	// draw background
	rl.DrawRectangleRec(box_rect, BG_COLOR)

	// draw text
	text_position := rl.Vector2{tx, ty}
	rl.DrawTextEx(font, text, text_position, FONT_SIZE, FONT_SPACING, TEXT_COLOR)
}
