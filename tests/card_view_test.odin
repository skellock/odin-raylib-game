#+feature using-stmt
package tests

import main "../src"
import "core:testing"
import rl "vendor:raylib"

@(test)
init_card_view_test :: proc(t: ^testing.T) {
	using main
	card := Card{.Ace, .Spade}
	tex := rl.Texture2D{0, 100, 140, 0, rl.PixelFormat.UNKNOWN}
	cv := init_card_view(card, tex)

	testing.expect_value(t, cv.card, card)
	testing.expect_value(t, cv.texture.width, i32(100))
	testing.expect_value(t, cv.texture.height, i32(140))
	testing.expect_value(t, cv.pos, rl.Vector2{0, 0})
}

@(test)
update_card_view_positions_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)
	update_card_view_positions(&game)
	card_views := game.card_views[:]

	// each card should be spaced apart by CARD_SPACING
	for i in 1 ..< len(card_views) {
		diff := card_views[i].pos - card_views[i - 1].pos
		testing.expect_value(t, diff, CARD_SPACING)
	}
}

@(test)
update_card_view_collisions_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	update_card_view_positions(&game)
	game.dot.current_pos = {0, 0}
	game.dot.size = 1.0

	// no collisions to start
	update_card_view_collisions(&game)
	for cv in game.card_views {
		testing.expect_value(t, cv.collided, false)
	}

	// then we collide with one of them
	collided := &game.card_views[4]
	game.dot.current_pos = collided.pos
	update_card_view_collisions(&game)
	for cv in game.card_views {
		testing.expect_value(t, cv.collided, cv == collided^)
	}
}
