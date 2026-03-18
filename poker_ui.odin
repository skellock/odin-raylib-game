package main

import rl "vendor:raylib"

draw_poker_hand_type_text :: proc(game: Game, input: Input) {
	text := game.poker_hand.hand_type_text

	FONT_SIZE :: f32(50)
	SPACING :: f32(1)
	MARGIN_TOP :: f32(10)

	font := assets.fonts.body

	// center text with the hand of cards
	first := game.card_views[0]
	last := game.card_views[len(game.card_views) - 1]
	card_w := f32(first.texture.width) * CARD_SCALE
	card_h := f32(first.texture.height) * CARD_SCALE
	hand_center_x := (first.pos.x + last.pos.x + card_w) / 2
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, SPACING)
	x := hand_center_x - text_size.x / 2
	y := first.pos.y + card_h + MARGIN_TOP

	rl.DrawTextEx(font, text, {x, y}, FONT_SIZE, SPACING, rl.WHITE)
}
