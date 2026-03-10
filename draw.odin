package main

import rl "vendor:raylib"

// The main drawing function called once per frame.
draw :: proc(game: Game, input: Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	draw_background(input)
	draw_cards(game, input)
	draw_poker_hand(game, input)
	draw_dot(game, input)
	draw_tooltip(game)
	draw_debug(input)
}

@(private = "file")
draw_background :: proc(input: Input) {
	rl.ClearBackground(rl.WHITE)

	x := input.viewport.width / 2
	rl.DrawRectangle(0, 0, x, input.viewport.height, rl.BLUE)
	rl.DrawRectangle(x, 0, x, input.viewport.height, rl.SKYBLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.viewport.height, rl.ColorAlpha(rl.WHITE, 0.5))
}

@(private = "file")
draw_cards :: proc(game: Game, input: Input) {
	SHADOW_OFFSET :: rl.Vector2{1, 1}

	for card, idx in game.hand {
		tex := game.card_images.cards[card]
		pos := game.card_positions[idx]
		rl.DrawTextureEx(tex, pos + SHADOW_OFFSET, 0, CARD_SCALE, rl.ColorAlpha(rl.BLACK, 0.1))
		rl.DrawTextureEx(tex, pos, 0, CARD_SCALE, rl.WHITE)

		// are we hovering over this card?
		if idx == game.hovered_card {
			draw_card_hover(tex, pos)
		}
	}
}

@(private = "file")
draw_card_hover :: proc(tex: rl.Texture2D, pos: rl.Vector2) {
	INSET :: f32(2)
	THICKNESS :: 3
	ROUNDNESS :: 0.25
	SEGMENTS :: 4

	card_w := f32(tex.width) * CARD_SCALE - INSET * 2
	card_h := f32(tex.height) * CARD_SCALE - INSET * 2

	rl.DrawRectangleRoundedLinesEx(
		{pos.x + INSET, pos.y + INSET, card_w, card_h},
		ROUNDNESS,
		SEGMENTS,
		THICKNESS,
		rl.GREEN,
	)
}

@(private = "file")
draw_poker_hand :: proc(game: Game, input: Input) {
	text: cstring
	switch game.poker_hand {
	case .Nothing:
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
