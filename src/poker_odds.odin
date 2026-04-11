package main

import "core:strings"
import rl "vendor:raylib"

poker_odds := [PokerHandType]f64 {
	.Nothing       = 0.0,
	.HighCard      = 1.0,
	.Pair          = 0.422569,
	.TwoPair       = 0.047539,
	.ThreeOfAKind  = 0.021128,
	.Straight      = 0.003925,
	.Flush         = 0.001965,
	.FullHouse     = 0.001441,
	.FourOfAKind   = 0.000240,
	.StraightFlush = 0.0000139,
	.RoyalFlush    = 0.00000154,
}

draw_poker_odds :: proc(game: ^Game) {
	if game.poker_hand.hand_type == .Nothing || game.poker_hand.hand_type == .HighCard do return

	FONT_SIZE :: f32(20)
	SPACING :: f32(1)
	MARGIN_BOTTOM :: f32(4)

	first_card_view := game.card_views[0]
	last_card_view := game.card_views[len(game.card_views) - 1]
	card_w := f32(first_card_view.texture.width) * CARD_SCALE
	hand_center_x := (first_card_view.pos.x + last_card_view.pos.x + card_w) / 2

	text := strings.clone_to_cstring(game.poker_hand.odds, context.temp_allocator)
	font := assets.fonts.body
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, SPACING)

	x := hand_center_x - text_size.x / 2
	y := first_card_view.pos.y - FONT_SIZE - MARGIN_BOTTOM

	rl.DrawTextEx(font, text, {x, y}, FONT_SIZE, SPACING, rl.WHITE)
}
