package main

import "core:fmt"
import rl "vendor:raylib"

// The main drawing function called once per frame.
draw :: proc(game: Game, input: Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	draw_background(input)
	draw_cards(game, input)
	draw_poker_hand_text(game, input)
	draw_poker_odds(game)
	draw_dot(game, input)
	draw_reshuffler(game, input)
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

	for cv, idx in game.hand {
		rl.DrawTextureEx(cv.texture, cv.pos + SHADOW_OFFSET, 0, CARD_SCALE, rl.ColorAlpha(rl.BLACK, 0.1))
		rl.DrawTextureEx(cv.texture, cv.pos, 0, CARD_SCALE, rl.WHITE)

		// are we hovering over this card?
		if idx == game.hovered_card {
			draw_card_hover(cv.texture, cv.pos)
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
draw_poker_hand_text :: proc(game: Game, input: Input) {
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

	FONT_SIZE :: i32(20)
	MARGIN_TOP :: i32(10)

	// center text with the hand of cards
	first := game.hand[0]
	last := game.hand[len(game.hand) - 1]
	card_w := f32(first.texture.width) * CARD_SCALE
	card_h := f32(first.texture.height) * CARD_SCALE
	hand_center_x := (first.pos.x + last.pos.x + card_w) / 2
	text_w := f32(rl.MeasureText(text, FONT_SIZE))
	x := i32(hand_center_x - text_w / 2)
	y := i32(first.pos.y + card_h) + MARGIN_TOP

	rl.DrawText(text, x, y, FONT_SIZE, rl.WHITE)
}

@(private = "file")
draw_poker_odds :: proc(game: Game) {
	if game.poker_hand == .Nothing || game.poker_hand == .HighCard do return

	FONT_SIZE :: i32(10)
	MARGIN_BOTTOM :: i32(4)

	odds := poker_odds[game.poker_hand]
	one_in := int(1.0 / odds + 0.5)
	text := fmt.ctprintf("1 in {}", format_with_commas(one_in, context.temp_allocator))

	first := game.hand[0]
	last := game.hand[len(game.hand) - 1]
	card_w := f32(first.texture.width) * CARD_SCALE
	hand_center_x := (first.pos.x + last.pos.x + card_w) / 2

	text_w := f32(rl.MeasureText(text, FONT_SIZE))
	x := i32(hand_center_x - text_w / 2)
	y := i32(first.pos.y) - FONT_SIZE - MARGIN_BOTTOM

	rl.DrawText(text, x, y, FONT_SIZE, rl.ColorAlpha(rl.WHITE, 0.7))
}
