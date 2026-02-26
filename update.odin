package main

update :: proc(game: ^Game, input: ^Input) {
	update_music(&game.music)
	update_dot(&game.dot, input, &game.sounds)
	if input.mouse.right_pressed {
		shuffle_deck(&game.deck)
		deal_to_hand(game)
	}
}
