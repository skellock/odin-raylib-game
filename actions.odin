package main

Actions :: struct {
	reshuffle: bool,
	move_dot:  bool,
}

resolve_actions :: proc(actions: ^Actions, game: Game, input: Input) {
	actions.reshuffle = input.mouse.right_pressed && !game.reshuffler.cooldown.active
	actions.move_dot = input.mouse.left_pressed
}
