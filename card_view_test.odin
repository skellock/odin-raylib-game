package main

import "core:testing"
import rl "vendor:raylib"

@(test)
init_card_view_test :: proc(t: ^testing.T) {
	card := Card {
		pip  = .Ace,
		suit = .Spade,
	}
	tex := rl.Texture2D {
		width  = 100,
		height = 140,
	}
	cv := init_card_view(card, tex)

	testing.expect_value(t, cv.card, card)
	testing.expect_value(t, cv.texture.width, i32(100))
	testing.expect_value(t, cv.texture.height, i32(140))
	testing.expect_value(t, cv.pos, rl.Vector2{0, 0})
}

@(test)
update_card_view_positions_test :: proc(t: ^testing.T) {
	hand := [5]CardView{}
	update_card_view_positions(hand[:])

	// each card should be spaced apart by CARD_SPACING
	for i in 1 ..< len(hand) {
		diff := hand[i].pos - hand[i - 1].pos
		testing.expect_value(t, diff, CARD_SPACING)
	}
}
