package main

import "core:strings"
import rl "vendor:raylib"

Keyboard :: struct {
	quit_pressed:           bool,
	pause_pressed:          bool,
	load_pressed:           bool,
	save_pressed:           bool,
	enter_pressed:          bool,
	backspace_pressed:      bool,
	backspace_word_pressed: bool,
	escape_pressed:         bool,
	slash_pressed:          bool,
	typed:                  string,
}

@(private = "file")
keyboard_read_characters :: proc() -> string {
	TYPED_MAX_CHARS :: 64

	typed_buf: [TYPED_MAX_CHARS]u8
	typed_len := 0

	// and then collect them all
	for {
		ch := rl.GetCharPressed()
		if ch == 0 { break }
		if ch >= 32 && ch < 127 && typed_len < TYPED_MAX_CHARS {
			typed_buf[typed_len] = u8(ch)
			typed_len += 1
		}
	}

	return strings.clone(string(typed_buf[:typed_len]), context.temp_allocator)
}

keyboard_update :: proc(keyboard: ^Keyboard) {
	ctrl_down := rl.IsKeyDown(.LEFT_CONTROL) || rl.IsKeyDown(.RIGHT_CONTROL)
	keyboard.escape_pressed = rl.IsKeyPressed(.ESCAPE)
	keyboard.enter_pressed = rl.IsKeyPressed(.ENTER)
	keyboard.slash_pressed = rl.IsKeyPressed(.SLASH)
	keyboard.backspace_pressed = !ctrl_down && (rl.IsKeyPressed(.BACKSPACE) || rl.IsKeyPressedRepeat(.BACKSPACE))
	keyboard.backspace_word_pressed = ctrl_down && (rl.IsKeyPressed(.W) || rl.IsKeyPressed(.BACKSPACE))
	keyboard.quit_pressed = rl.IsKeyPressed(.Q)
	keyboard.pause_pressed = rl.IsKeyPressed(.P)
	keyboard.load_pressed = rl.IsKeyPressed(.L)
	keyboard.save_pressed = rl.IsKeyPressed(.S)
	keyboard.typed = keyboard_read_characters()
}
