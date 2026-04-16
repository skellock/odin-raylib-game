package main

import "core:fmt"
import rl "vendor:raylib"

Clock :: struct {
	elapsed: f64, // seconds accumulated since the clock was started
}

clock_init :: proc() -> Clock {
	return Clock{}
}

// Accumulates delta time every frame regardless of pause state.
clock_update :: proc(game: ^Game) {
	game.clock.elapsed += f64(game.time.dt)
}

// Formats the elapsed time.
clock_format_elapsed :: proc(elapsed: f64, buf: []byte) -> string {
	total_seconds := int(elapsed)
	hours := total_seconds / 3600
	minutes := (total_seconds % 3600) / 60
	seconds := total_seconds % 60
	tenths := int(elapsed * 10) % 10
	if hours > 0 {
		return fmt.bprintf(buf, "%d:%02d:%02d.%d", hours, minutes, seconds, tenths)
	}
	if minutes > 0 {
		return fmt.bprintf(buf, "%d:%02d.%d", minutes, seconds, tenths)
	}
	return fmt.bprintf(buf, "%d.%d", seconds, tenths)
}

clock_draw :: proc(game: ^Game) {
	FONT_SIZE :: f32(24)
	FONT_SPACING :: f32(2)
	EDGE_OFFSET :: f32(8) // gap between screen edge and the box
	H_PADDING :: f32(12) // horizontal padding inside the box
	V_PADDING :: f32(8) // vertical padding inside the box
	BG_COLOR: rl.Color : {0, 0, 0, 128}
	TEXT_COLOR :: rl.WHITE
	BOX_ROUNDNESS :: f32(0.4)
	BOX_SEGMENTS :: i32(8)

	// create the text
	buf: [32]byte
	text := fmt.ctprintf("%s", clock_format_elapsed(game.clock.elapsed, buf[:]))

	// measure it
	font := assets.fonts.body
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, FONT_SPACING)
	tw := text_size.x
	th := text_size.y

	// draw a box
	box_w := tw + H_PADDING * 2
	box_h := th + V_PADDING * 2
	box_x := EDGE_OFFSET
	box_y := f32(game.viewport.height) - box_h - EDGE_OFFSET
	box_rect := rl.Rectangle{box_x, box_y, box_w, box_h}
	rl.DrawRectangleRounded(box_rect, BOX_ROUNDNESS, BOX_SEGMENTS, BG_COLOR)

	// draw the text
	tx := box_x + (box_w - tw) / 2
	ty := box_y + (box_h - th) / 2
	text_position := rl.Vector2{tx, ty}
	rl.DrawTextEx(font, text, text_position, FONT_SIZE, FONT_SPACING, TEXT_COLOR)
}
