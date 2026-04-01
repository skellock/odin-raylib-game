package main

import rl "vendor:raylib"

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
}

update_actions :: proc(game: ^Game) {
	// start by resetting the actions entirely
	game.actions = Actions{}

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
