package main

MoveDotAction :: struct {
	active: bool,
	x:      f32,
	y:      f32,
}

Actions :: struct {
	reshuffle: bool,
	move_dot:  MoveDotAction,
}

reset_actions :: proc(actions: ^Actions) {
	actions.reshuffle = false
	actions.move_dot = {}
}

resolve_actions :: proc(actions: ^Actions, game: Game, input: Input) {
	// clear all the actions
	reset_actions(actions)

	if input.mouse.right_pressed && !game.reshuffler.cooldown.active {
		actions.reshuffle = true
	}

	if input.mouse.left_pressed {
		actions.move_dot = {true, input.mouse.world_x, input.mouse.world_y}
	}

}
