package main

import rl "vendor:raylib"

MoveDotAction :: struct {
	active: bool,
	pos:    rl.Vector2,
}

Actions :: struct {
	reshuffle: bool,
	move_dot:  MoveDotAction,
	quit_game: bool,
	toggle_pause: bool,
}

resolve_actions :: proc(actions: ^Actions, game: Game, input: Input) {
	// start by resetting the actions entirely
	actions^ = Actions{}

	if input.keyboard.quit_pressed {
		actions.quit_game = true
	}

	if input.keyboard.pause_pressed {
		actions.toggle_pause = true
	}

	if input.mouse.right_pressed && !game.reshuffler.cooldown.active {
		actions.reshuffle = true
	}

	if input.mouse.left_pressed {
		actions.move_dot = {true, input.mouse.world_pos}
	}
}
