package main

import rl "vendor:raylib"

draw :: proc(game: ^Game, input: ^Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	draw_background(input)
	draw_title()
	draw_cards(game, input)
	draw_poker_hand(game, input)
	draw_dot(&game.dot, input)
	draw_debug(input)
}

@(private = "file")
draw_background :: proc(input: ^Input) {
	rl.ClearBackground(rl.WHITE)

	x := input.viewport.width / 2
	rl.DrawRectangle(0, 0, x, input.viewport.height, rl.BLUE)
	rl.DrawRectangle(x, 0, x, input.viewport.height, rl.SKYBLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.viewport.height, rl.ColorAlpha(rl.WHITE, 0.5))
}

@(private = "file")
draw_title :: proc() {
	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 8, rl.WHITE)
}

@(private = "file")
draw_cards :: proc(game: ^Game, input: ^Input) {
	SHADOW_OFFSET :: rl.Vector2{1, 1}
	pos := rl.Vector2{200, 200}
	rot := f32(-10)
	for card in game.hand {
		card_code := get_card_code(card)
		defer delete(card_code)
		tex := game.card_images.cards[card_code]
		rl.DrawTextureEx(tex, pos + SHADOW_OFFSET, rot, 1.0 / 3.0, rl.ColorAlpha(rl.BLACK, 0.1))
		rl.DrawTextureEx(tex, pos, rot, 1.0 / 3.0, rl.WHITE)
		pos += {25, rot}
		rot += 5
	}
}

@(private = "file")
draw_poker_hand :: proc(game: ^Game, input: ^Input) {
	text: cstring
	switch game.poker_hand {
	case .None:
		text = "Nothing"
	case .HighCard:
		text = "High Card"
	case .Pair:
		text = "Pair"
	case .TwoPair:
		text = "Two Pair"
	case .ThreeOfAKind:
		text = "Three of a Kind"
	case .Straight:
		text = "Straight"
	case .Flush:
		text = "Flush"
	case .FullHouse:
		text = "Full House"
	case .FourOfAKind:
		text = "Four of a Kind"
	case .StraightFlush:
		text = "Straight Flush"
	case .RoyalFlush:
		text = "Royal Flush"
	}

	rl.DrawText(text, 200, 300, 20, rl.WHITE)
}
