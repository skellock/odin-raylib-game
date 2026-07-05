package main

ConsoleAction :: struct {
	show:           bool,
	hide:           bool,
	backspace:      bool,
	backspace_word: bool,
	clear:          bool,
	typed:          string,
}

MoveDotAction :: struct {
	active: bool,
	pos:    [2]f32,
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

actions_update :: proc(game: ^Game) {
	// start by resetting the actions entirely
	game.actions = Actions{}

	// establish some shortcuts
	keyboard := &game.keyboard
	mouse := &game.mouse
	console := game.console
	actions := &game.actions

	if console.active {
		// console is up
		actions.console.hide = keyboard.escape_pressed || keyboard.enter_pressed
		actions.console.clear = actions.console.hide
		actions.console.backspace = keyboard.backspace_pressed
		actions.console.backspace_word = keyboard.backspace_word_pressed
		actions.console.typed = keyboard.typed

		// map console input to a command
		if keyboard.enter_pressed {
			switch console_get_value(console) {
			case "quit": actions.quit_game = true
			case "pause": actions.toggle_pause = true
			case "load": actions.load_game = true
			case "save": actions.save_game = true
			}
		}
	} else {
		// regular game play
		actions.console.show = keyboard.slash_pressed
		actions.quit_game = keyboard.quit_pressed
		actions.load_game = keyboard.load_pressed
		actions.save_game = keyboard.save_pressed
		actions.toggle_pause = keyboard.pause_pressed

		if mouse.right_pressed && !game.reshuffler.cooldown.active { actions.reshuffle = true }
		if mouse.left_pressed { actions.move_dot = {true, mouse.world_pos} }
	}
}
