package main

import "core:fmt"
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

draw_poker_odds :: proc(game: Game) {
	if game.poker_hand_type == .Nothing || game.poker_hand_type == .HighCard do return

	FONT_SIZE :: i32(10)
	MARGIN_BOTTOM :: i32(4)

	odds := poker_odds[game.poker_hand_type]
	one_in := int(1.0 / odds + 0.5)
	text := fmt.ctprintf("1 in {}", format_with_commas(one_in, context.temp_allocator))

	first := game.card_views[0]
	last := game.card_views[len(game.card_views) - 1]
	card_w := f32(first.texture.width) * CARD_SCALE
	hand_center_x := (first.pos.x + last.pos.x + card_w) / 2

	text_w := f32(rl.MeasureText(text, FONT_SIZE))
	x := i32(hand_center_x - text_w / 2)
	y := i32(first.pos.y) - FONT_SIZE - MARGIN_BOTTOM

	rl.DrawText(text, x, y, FONT_SIZE, rl.ColorAlpha(rl.WHITE, 0.7))
}
