package main

import rl "vendor:raylib"

CARD_SCALE :: f32(1.0 / 3.0)

// The main update statement called once per frame.
update :: proc(game: ^Game, input: Input) {
	update_music(&game.music)
	update_dot(&game.dot, input, game.sounds)
	update_card_positions(game)
	update_tooltip(game, input)
	update_timer(&game.reshuffle_cooldown, input.time.dt)

	if input.mouse.right_pressed && !game.reshuffle_cooldown.active {
		shuffle_deck(&game.deck)
		deal_to_hand(game)
		start_timer(&game.reshuffle_cooldown)
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
