package main

import rl "vendor:raylib"

CARD_SCALE :: f32(1.0 / 3.0)

update :: proc(game: ^Game, input: ^Input) {
	update_music(&game.music)
	update_dot(&game.dot, input, &game.sounds)
	update_card_positions(game)
	update_tooltip(game, input)

	if input.mouse.right_pressed {
		shuffle_deck(&game.deck)
		deal_to_hand(game)
	}
}

update_card_positions :: proc(game: ^Game) {
	CARD_SPACING :: rl.Vector2{25, 0}
	pos := rl.Vector2{200, 200}
	for idx in 0 ..< len(game.hand) {
		game.card_positions[idx] = pos
		pos += CARD_SPACING
	}
}
