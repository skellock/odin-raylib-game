package main

import rl "vendor:raylib"

TYPED_MAX_CHARS :: 64

Keyboard :: struct {
	quit_pressed:      bool,
	pause_pressed:     bool,
	load_pressed:      bool,
	save_pressed:      bool,
	enter_pressed:     bool,
	backspace_pressed: bool,
	escape_pressed:    bool,
	slash_pressed:     bool,
	typed_buf:         [TYPED_MAX_CHARS]u8,
	typed_len:         int,
}

update_keyboard :: proc(game: ^Game) {
	k := &game.keyboard

	k.escape_pressed = rl.IsKeyPressed(.ESCAPE)
	k.enter_pressed = rl.IsKeyPressed(.ENTER)
	k.slash_pressed = rl.IsKeyPressed(.SLASH)
	k.backspace_pressed = rl.IsKeyPressed(.BACKSPACE) || rl.IsKeyPressedRepeat(.BACKSPACE)

	if !game.console.active {
		k.quit_pressed = rl.IsKeyPressed(.Q)
		k.pause_pressed = rl.IsKeyPressed(.P)
		k.load_pressed = rl.IsKeyPressed(.L)
		k.save_pressed = rl.IsKeyPressed(.S)
	}

	// reset they characters the user has typed this frame
	k.typed_len = 0

	// and then collect them all
	for {
		ch := rl.GetCharPressed()
		if ch == 0 do break
		if ch >= 32 && ch < 127 && k.typed_len < TYPED_MAX_CHARS {
			k.typed_buf[k.typed_len] = u8(ch)
			k.typed_len += 1
		}
	}
}
