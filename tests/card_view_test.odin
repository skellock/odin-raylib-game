package tests

import main ".."
import "core:testing"
import rl "vendor:raylib"

@(test)
init_card_view_test :: proc(t: ^testing.T) {
	card := main.Card {
		pip  = .Ace,
		suit = .Spade,
	}
	tex := rl.Texture2D {
		width  = 100,
		height = 140,
	}
	cv := main.init_card_view(card, tex)

	testing.expect_value(t, cv.card, card)
	testing.expect_value(t, cv.texture.width, i32(100))
	testing.expect_value(t, cv.texture.height, i32(140))
	testing.expect_value(t, cv.pos, rl.Vector2{0, 0})
}

@(test)
update_card_view_positions_test :: proc(t: ^testing.T) {
	g := main.init_game()
	defer main.destroy_game(&g)
	main.update_card_view_positions(&g)
	card_views := g.card_views[:]

	// each card should be spaced apart by CARD_SPACING
	for i in 1 ..< len(card_views) {
		diff := card_views[i].pos - card_views[i - 1].pos
		testing.expect_value(t, diff, main.CARD_SPACING)
	}
}
