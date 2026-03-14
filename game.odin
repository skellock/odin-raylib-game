package main

import rl "vendor:raylib"

Game :: struct {
	dot:             Dot,
	camera:          rl.Camera2D,
	deck:            Deck,
	card_views:      [dynamic]CardView,
	poker_hand_type: PokerHandType,
	tooltip:         Tooltip,
	hovered_card:    int,
	reshuffler:      Reshuffler,
}

init_game :: proc(card_images: CardImages) -> Game {
	deck := init_shuffled_deck()
	card_views := make([dynamic]CardView)

	game := Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
		deck = deck,
		card_views = card_views,
		reshuffler = init_reshuffler(),
	}
	deal_to_hand(&game, card_images)

	return game
}

deal_to_hand :: proc(game: ^Game, card_images: CardImages) {
	clear(&game.card_views)
	for i in 0 ..< 5 {
		card := game.deck.cards[i]
		tex := card_images.cards[card]
		append(&game.card_views, init_card_view(card, tex))
	}
	game.poker_hand_type = score_hand(hand_cards(game.card_views[:], context.temp_allocator))
	update_card_view_positions(game.card_views[:])
}

hand_cards :: proc(hand: []CardView, allocator := context.allocator) -> []Card {
	cards := make([]Card, len(hand), allocator)
	for cv, i in hand {
		cards[i] = cv.card
	}
	return cards
}

destroy_game :: proc(game: ^Game) {
	destroy_dot(&game.dot)
	destroy_reshuffler(&game.reshuffler)
	delete(game.card_views)
}
