package main

import rl "vendor:raylib"

Game :: struct {
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
}

init_game :: proc() -> Game {
	game := Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = 1},
		// camera = rl.Camera2D{zoom = f32(rl.GetRenderHeight() / VIEWPORT_HEIGHT)},
		deck = init_shuffled_deck(),
		reshuffler = init_reshuffler(),
		scarfy = init_scarfy(),
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
}
