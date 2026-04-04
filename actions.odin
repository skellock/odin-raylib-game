package main

import rl "vendor:raylib"

ConsoleAction :: struct {
	show:      bool,
	hide:      bool,
	backspace: bool,
	clear:     bool,
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

@(private = "file")
update_console_actions :: proc(game: ^Game) {
	c := &game.actions.console

	if game.console.active {
		c.hide = game.keyboard.escape_pressed || game.keyboard.enter_pressed
		c.clear = c.hide
		c.backspace = game.keyboard.backspace_pressed

		if game.keyboard.enter_pressed {
			value := get_console_value(&game.console)
			game.actions.quit_game = value == "quit"
		}
	} else {
		c.show = game.keyboard.slash_pressed
	}
}

update_actions :: proc(game: ^Game) {
	// start by resetting the actions entirely
	game.actions = Actions{}

	update_console_actions(game)

	if game.keyboard.quit_pressed {
		game.actions.quit_game = true
	}

	if game.keyboard.pause_pressed {
		game.actions.toggle_pause = true
	}

	if game.mouse.right_pressed && !game.reshuffler.cooldown.active {
		game.actions.reshuffle = true
	}

	if game.mouse.left_pressed {
		game.actions.move_dot = {true, game.mouse.world_pos}
	}

	if game.keyboard.load_pressed {
		load_save_game(game)
	}

	if game.keyboard.save_pressed {
		write_save_game(game)
	}
}
