package main

import "core:fmt"
import rl "vendor:raylib"

Debug :: struct {
	text: TextCache,
	fps:  i32,
}

debug_cache_text :: proc(debug: ^Debug, fps: i32) {
	if debug.text.length > 0 && debug.fps == fps { return }
	buf: [32]byte
	text_cache_set(&debug.text, fmt.bprintf(buf[:], "FPS: %d", fps))
	debug.fps = fps
}

// Draws an FPS thingy.
debug_draw :: proc(game: ^Game) {
	FONT_SIZE := 16 * rl.GetWindowScaleDPI().y
	FONT_SPACING := 2 * rl.GetWindowScaleDPI().y
	H_MARGIN :: f32(4)
	V_MARGIN :: f32(4)
	BG_COLOR: rl.Color : {0, 0, 0, 128}
	TEXT_COLOR :: rl.WHITE

	// what to print
	debug := &game.debug
	debug_cache_text(debug, rl.GetFPS())
	text := text_cache_cstring(&debug.text)

	// calculate locations
	font := assets.fonts.body
	text_size := text_cache_measure(&debug.text, font, FONT_SIZE, FONT_SPACING)
	tw := text_size.x
	th := text_size.y
	tx := f32(rl.GetRenderWidth()) - H_MARGIN * 2 - tw
	ty := V_MARGIN
	box_rect := rl.Rectangle{tx - H_MARGIN, ty - V_MARGIN, tw + H_MARGIN * 4, th + V_MARGIN * 2}

	// draw background
	rl.DrawRectangleRec(box_rect, BG_COLOR)

	// draw text
	text_position := rl.Vector2{tx, ty}
	rl.DrawTextEx(font, text, text_position, FONT_SIZE, FONT_SPACING, TEXT_COLOR)
}
