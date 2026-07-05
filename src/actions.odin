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

// Process the actions related to the game.
actions_gameplay_update :: proc(game: ^Game) {
	actions := Actions{}
	actions.console.show = game.keyboard.slash_pressed
	actions.quit_game = game.keyboard.quit_pressed
	actions.load_game = game.keyboard.load_pressed
	actions.save_game = game.keyboard.save_pressed
	actions.toggle_pause = game.keyboard.pause_pressed

	if game.mouse.right_pressed && !game.reshuffler.cooldown.active {
		actions.reshuffle = true
	}
	if game.mouse.left_pressed {
		actions.move_dot = {true, game.mouse.world_pos}
	}

	game.actions = actions
}

// Process the actions when the console is up.
actions_console_update :: proc(game: ^Game) {
	actions := Actions{}

	actions.console.hide = game.keyboard.escape_pressed || game.keyboard.enter_pressed
	actions.console.clear = actions.console.hide
	actions.console.backspace = game.keyboard.backspace_pressed
	actions.console.backspace_word = game.keyboard.backspace_word_pressed
	actions.console.typed = game.keyboard.typed

	// map console input to a command
	if game.keyboard.enter_pressed {
		switch console_get_value(game.console) {
		case "quit": actions.quit_game = true
		case "pause": actions.toggle_pause = true
		case "load": actions.load_game = true
		case "save": actions.save_game = true
		}
	}

	game.actions = actions
}

actions_update :: proc(game: ^Game) {
	if game.console.active {
		actions_console_update(game)
	} else {
		actions_gameplay_update(game)
	}
}
