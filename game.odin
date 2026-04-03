package main

import rl "vendor:raylib"

Game :: struct {
	clock:        Clock,
	time:         Time,
	screen:       Screen,
	viewport:     Viewport,
	keyboard:     Keyboard,
	mouse:        Mouse,
	actions:      Actions,
	dot:          Dot,
	camera:       rl.Camera2D,
	deck:         Deck,
	card_views:   [5]CardView,
	poker_hand:   PokerHand,
	tooltip:      Tooltip,
	hovered_card: int,
	reshuffler:   Reshuffler,
	paused:       bool,
	scarfy:       Scarfy,
	tiling:       Tiling,
}

init_game :: proc() -> Game {
	game := Game {
		clock = init_clock(),
		dot = init_dot(),
		camera = rl.Camera2D{zoom = 1},
		// camera = rl.Camera2D{zoom = f32(rl.GetRenderHeight() / VIEWPORT_HEIGHT)},
		deck = init_shuffled_deck(),
		reshuffler = init_reshuffler(),
		scarfy = init_scarfy(),
		tiling = init_tiling(),
	}
	deal_to_hand(&game)

	return game
}

deal_to_hand :: proc(game: ^Game) {
	game.poker_hand = init_poker_hand(game.deck.cards[:5])
	for card, i in game.poker_hand.cards {
		tex := assets.card_images.cards[card]
		game.card_views[i] = init_card_view(card, tex)
	}
	update_card_view_positions(game)
}

destroy_game :: proc(game: ^Game) {
	destroy_dot(&game.dot)
	destroy_reshuffler(&game.reshuffler)
	destroy_scarfy(&game.scarfy)
	destroy_tiling(&game.tiling)
}

restore_save_game :: proc(game: ^Game, save: ^SaveGame) {
	game.deck.cards = save.cards
	game.dot.current_pos = {save.dot_x, save.dot_y}
	game.dot.color = save.dot_color

	// update dependent game state
	clear_dot_tweens(game)
	deal_to_hand(game)
}

build_save_game :: proc(game: ^Game) -> SaveGame {
	return SaveGame {
		cards = game.deck.cards,
		dot_x = game.dot.current_pos[0],
		dot_y = game.dot.current_pos[1],
		dot_color = game.dot.color,
	}
}
