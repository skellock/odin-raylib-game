package main

import "core:strings"
import rl "vendor:raylib"

CONSOLE_WIDTH :: 600
CONSOLE_HEIGHT :: 50
CONSOLE_FONT_SIZE :: 28
CONSOLE_MAX_CHARS :: 64

Console :: struct {
	buf:    [CONSOLE_MAX_CHARS]u8,
	len:    int,
	active: bool,
}

init_console :: proc() -> Console {
	return Console{}
}

update_console :: proc(game: ^Game) {
	c := &game.console
	ca := &game.actions.console

	if ca.show do c.active = true
	if ca.hide do c.active = false
	if ca.clear do clear_console(c)
	if ca.backspace && c.len > 0 do c.len -= 1

	if !c.active do return

	// clicking outside the console hides it
	if rl.IsMouseButtonPressed(.LEFT) {
		box := rl.Rectangle {
			f32(game.viewport.width / 2 - CONSOLE_WIDTH / 2),
			f32(game.viewport.height - CONSOLE_HEIGHT - 10),
			CONSOLE_WIDTH,
			CONSOLE_HEIGHT,
		}
		if !rl.CheckCollisionPointRec(game.mouse.screen_pos, box) {
			c.active = false
			clear_console(c)
		}
	}

	// Don't gather input on the same frame of showing. This prevents the slash character
	// from showing up when we use it to active the console.
	if !ca.show {
		// gather typed characters -- TODO: relocate into console actions?
		for {
			ch := rl.GetCharPressed()
			if ch == 0 do break
			if ch >= 32 && ch < 127 && c.len < CONSOLE_MAX_CHARS {
				c.buf[c.len] = u8(ch)
				c.len += 1
			}
		}
	}
}

get_console_value :: proc(c: ^Console) -> string {
	return string(c.buf[:c.len])
}

clear_console :: proc(c: ^Console) {
	c.len = 0
}

draw_console :: proc(game: ^Game) {
	c := &game.console
	if !c.active do return

	box_x := f32(game.viewport.width / 2 - CONSOLE_WIDTH / 2)
	box_y := f32(game.viewport.height - CONSOLE_HEIGHT - 10)

	// background
	rl.DrawRectangle(i32(box_x), i32(box_y), CONSOLE_WIDTH, CONSOLE_HEIGHT, rl.LIGHTGRAY)
	// border
	border_color := rl.BLUE if c.active else rl.DARKGRAY
	rl.DrawRectangleLinesEx({box_x, box_y, CONSOLE_WIDTH, CONSOLE_HEIGHT}, 2, border_color)

	// text
	text := strings.clone_to_cstring(get_console_value(c), context.temp_allocator)
	spacing := f32(CONSOLE_FONT_SIZE / 10)
	text_size := rl.MeasureTextEx(rl.GetFontDefault(), text, CONSOLE_FONT_SIZE, spacing)
	text_x := i32(box_x) + 5
	text_y := i32(box_y) + (CONSOLE_HEIGHT - i32(text_size.y)) / 2
	rl.DrawText(text, text_x, text_y, CONSOLE_FONT_SIZE, rl.BLACK)

	// blinking caret
	if int(game.time.elapsed * 2) % 2 == 0 {
		caret_x := f32(text_x) + text_size.x + 2
		caret_y := box_y + f32((CONSOLE_HEIGHT - CONSOLE_FONT_SIZE) / 2)
		rl.DrawRectangle(i32(caret_x), i32(caret_y), 2, CONSOLE_FONT_SIZE, rl.BLACK)
	}
}
