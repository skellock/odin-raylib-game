package main

import rl "vendor:raylib"

ConsoleAction :: struct {
	show:      bool,
	hide:      bool,
	backspace: bool,
	clear:     bool,
	typed:     string,
}

MoveDotAction :: struct {
	active: bool,
	pos:    rl.Vector2,
}

Actions :: struct {
	reshuffle:    bool,
	move_dot:     MoveDotAction,
	quit_game:    bool,
	toggle_pause: bool,
	save_game:    bool,
	load_game:    bool,
	console:      ConsoleAction,
}

update_actions :: proc(game: ^Game) {
	// start by resetting the actions entirely
	game.actions = Actions{}

	// establish some shortcuts
	kb := &game.keyboard
	mouse := &game.mouse
	con := &game.console
	acts := &game.actions

	if con.active {
		// console is up
		acts.console.hide = kb.escape_pressed || kb.enter_pressed
		acts.console.clear = acts.console.hide
		acts.console.backspace = kb.backspace_pressed
		acts.console.typed = string(kb.typed_buf[:kb.typed_len])

		// map console input to a command
		if kb.enter_pressed {
			switch get_console_value(con) {
			case "quit":
				acts.quit_game = true
			}
		}
	} else {
		// regular game play
		acts.console.show = kb.slash_pressed
		acts.quit_game = kb.quit_pressed
		acts.load_game = kb.load_pressed
		acts.save_game = kb.save_pressed
		acts.toggle_pause = kb.pause_pressed

		if mouse.right_pressed && !game.reshuffler.cooldown.active do acts.reshuffle = true
		if mouse.left_pressed do acts.move_dot = {true, mouse.world_pos}
	}
}
