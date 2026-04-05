package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

CONSOLE_WIDTH :: 600
CONSOLE_HEIGHT :: 50
CONSOLE_FONT_SIZE :: 28
CONSOLE_MAX_CHARS :: 64

CONSOLE_ANIM_SPEED :: 16.0

Console :: struct {
	builder:   strings.Builder,
	active:    bool,
	animation: f32, // 0 = hidden (offscreen), 1 = fully visible
}

init_console :: proc() -> Console {
	result := Console{}
	strings.builder_init(&result.builder)
	return result
}

destroy_console :: proc(console: ^Console) {
	strings.builder_destroy(&console.builder)
}

update_console :: proc(game: ^Game) {
	c := &game.console
	ca := &game.actions.console

	if ca.show do c.active = true
	if ca.hide do c.active = false
	if ca.clear do clear_console(c)

	// animate
	target: f32 = 1.0 if c.active else 0.0
	c.animation =
		c.animation + (target - c.animation) * min(CONSOLE_ANIM_SPEED * game.time.dt, 1.0)
	if c.animation < 0.01 do c.animation = 0
	if c.animation > 0.99 do c.animation = 1

	// backspace has been pressed -- TODO: this could be nicer
	if ca.backspace && len(c.builder.buf) > 0 {
		old_string := strings.to_string(c.builder)
		strings.builder_reset(&c.builder)
		strings.write_string(&c.builder, old_string[:len(old_string) - 1])
	}

	// backspace word: delete back to previous space (inclusive), or clear all
	if ca.backspace_word && len(c.builder.buf) > 0 {
		val := strings.to_string(c.builder)
		// trim trailing spaces first, then find the previous space
		trimmed := strings.trim_right(val, " ")
		idx := strings.last_index(trimmed, " ")
		strings.builder_reset(&c.builder)
		if idx >= 0 {
			strings.write_string(&c.builder, trimmed[:idx])
		}
	}

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
		strings.write_string(&c.builder, ca.typed)
	}
}

get_console_value :: proc(c: ^Console) -> string {
	return strings.to_string(c.builder)
}

clear_console :: proc(c: ^Console) {
	strings.builder_reset(&c.builder)
}

draw_console :: proc(game: ^Game) {
	FONT_SIZE :: f32(24)
	FONT_SPACING :: f32(2)
	H_PADDING :: i32(12)
	V_PADDING :: i32(8)
	BG_COLOR: rl.Color : {0, 0, 0, 128}
	TEXT_COLOR :: rl.WHITE
	INDICATOR :: ">"
	CARET_BLINK_RATE :: 2

	c := &game.console
	if c.animation <= 0 do return

	font := assets.fonts.body
	text := fmt.ctprintf("%s", get_console_value(c))

	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, FONT_SPACING)
	min_height := rl.MeasureTextEx(font, "A", FONT_SIZE, FONT_SPACING).y
	tw := i32(text_size.x)
	th := i32(max(text_size.y, min_height))

	box_w := i32(CONSOLE_WIDTH)
	box_h := th + V_PADDING * 2
	box_x := game.viewport.width / 2 - box_w / 2
	rest_y := game.viewport.height - box_h - 10
	offscreen_y := game.viewport.height
	box_y := rest_y + i32(f32(offscreen_y - rest_y) * (1.0 - c.animation))

	// center text vertically inside the box
	tx := box_x + H_PADDING
	ty := box_y + (box_h - th) / 2

	rl.DrawRectangleRounded({f32(box_x), f32(box_y), f32(box_w), f32(box_h)}, 0.4, 8, BG_COLOR)

	// prompt indicator (drawn before scissor so it's never clipped)
	prompt_size := rl.MeasureTextEx(font, INDICATOR, FONT_SIZE, FONT_SPACING)
	rl.DrawTextEx(font, INDICATOR, {f32(tx), f32(ty)}, FONT_SIZE, FONT_SPACING, TEXT_COLOR)
	text_left := f32(tx) + prompt_size.x + f32(H_PADDING / 2)

	available_w := f32(box_x + box_w - H_PADDING) - text_left
	text_draw_x := text_left
	if text_size.x > available_w {
		text_draw_x = text_left - (text_size.x - available_w)
	}

	// clip text area to the region after the prompt
	scissor_x := i32(text_left)
	scissor_w := box_x + box_w - scissor_x
	rl.BeginScissorMode(scissor_x, box_y, scissor_w, box_h)
	defer rl.EndScissorMode()

	rl.DrawTextEx(font, text, {text_draw_x, f32(ty)}, FONT_SIZE, FONT_SPACING, TEXT_COLOR)

	// blinking caret if the console is fully visible
	if int(game.time.elapsed * CARET_BLINK_RATE) % 2 == 0 && c.animation == 1 {
		caret_x := text_draw_x + text_size.x + 2
		caret_h := th
		caret_y := f32(ty)
		rl.DrawRectangle(i32(caret_x), i32(caret_y), 2, caret_h, TEXT_COLOR)
	}
}
