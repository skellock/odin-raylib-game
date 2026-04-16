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
	console:      Console,
}

game_init :: proc() -> Game {
	game := Game {
		clock = clock_init(),
		dot = dot_init(),
		camera = rl.Camera2D{zoom = 1},
		// camera = rl.Camera2D{zoom = f32(rl.GetRenderHeight() / VIEWPORT_HEIGHT)},
		deck = deck_init_shuffled(),
		reshuffler = reshuffler_init(),
		scarfy = scarfy_init(),
		tiling = tiling_init(),
		console = console_init(),
	}
	game_deal_to_hand(&game)

	return game
}

game_deal_to_hand :: proc(game: ^Game) {
	poker_hand_destroy(&game.poker_hand)
	game.poker_hand = poker_hand_init(game.deck.cards[:5])
	for card, i in game.poker_hand.cards {
		tex := assets.card_images.cards[card]
		game.card_views[i] = card_view_init(card, tex)
	}
	card_view_update_all_positions(game)
}

game_destroy :: proc(game: ^Game) {
	dot_destroy(&game.dot)
	reshuffler_destroy(&game.reshuffler)
	scarfy_destroy(&game.scarfy)
	tiling_destroy(&game.tiling)
	console_destroy(&game.console)
	poker_hand_destroy(&game.poker_hand)
}

game_restore_save_game :: proc(game: ^Game, save: ^SaveGame) {
	game.deck.cards = save.cards
	game.dot.current_pos = {save.dot_x, save.dot_y}
	game.dot.color = save.dot_color

	// update dependent game state
	dot_clear_tweens(game)
	game_deal_to_hand(game)
}

game_build_save_game :: proc(game: ^Game) -> SaveGame {
	return SaveGame {
		cards = game.deck.cards,
		dot_x = game.dot.current_pos[0],
		dot_y = game.dot.current_pos[1],
		dot_color = game.dot.color,
	}
}
