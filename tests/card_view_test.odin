#+feature using-stmt
package tests

import main "../src"
import "core:testing"
import rl "vendor:raylib"

@(test)
card_view_init_test :: proc(t: ^testing.T) {
	using main, testing

	card := Card{.Ace, .Spade}
	tex := rl.Texture2D{0, 100, 140, 0, rl.PixelFormat.UNKNOWN}
	cv := card_view_init(card, tex)

	expect_value(t, cv.card, card)
	expect_value(t, cv.texture.width, i32(100))
	expect_value(t, cv.texture.height, i32(140))
	expect_value(t, cv.pos, rl.Vector2{0, 0})
}

@(test)
card_view_update_positions_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	card_view_update_all_positions(&game)
	card_views := game.card_views[:]

	// each card should be spaced apart by CARD_SPACING
	for i in 1 ..< len(card_views) {
		diff := card_views[i].pos - card_views[i - 1].pos
		expect_value(t, diff, CARD_SPACING)
	}
}

@(test)
card_view_update_collisions_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	card_view_update_all_positions(&game)
	game.dot.current_pos = {0, 0}
	game.dot.size = 1.0

	// no collisions to start
	card_view_update_all_collisions(&game)
	for cv in game.card_views {
		expect_value(t, cv.collided, false)
	}

	// then we collide with one of them
	collided := &game.card_views[4]
	game.dot.current_pos = collided.pos
	card_view_update_all_collisions(&game)
	for cv in game.card_views {
		expect_value(t, cv.collided, cv == collided^)
	}
}
