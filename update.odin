package main

// The main update statement called once per frame.
update :: proc(game: ^Game, input: Input) {
	update_music(&game.music)
	update_dot(&game.dot, input, game.sounds)
	update_card_view_positions(game.hand[:])
	update_tooltip(game, input)
	update_reshuffler(game, input)
}
