package main

import rl "vendor:raylib"

CARD_SCALE :: f32(1.0 / 2.0)
CARD_SPACING :: rl.Vector2{70, 0}

CardView :: struct {
	card:     Card,
	pos:      rl.Vector2,
	texture:  rl.Texture2D,
	collided: bool,
}

init_card_view :: proc(card: Card, texture: rl.Texture2D) -> CardView {
	return CardView{card = card, texture = texture}
}

draw_card_views :: proc(game: ^Game) {
	SHADOW_OFFSET :: rl.Vector2{1, 1}

	for cv, idx in game.card_views {
		rl.DrawTextureEx(cv.texture, cv.pos + SHADOW_OFFSET, 0, CARD_SCALE, rl.ColorAlpha(rl.BLACK, 0.1))
		color := cv.collided ? get_dot_drawing_color(game) : rl.WHITE
		rl.DrawTextureEx(cv.texture, cv.pos, 0, CARD_SCALE, color)

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

update_card_view_positions :: proc(game: ^Game) {
	hand := game.card_views[:]
	pos := rl.Vector2{200, 200}
	for idx in 0 ..< len(hand) {
		hand[idx].pos = pos
		pos += CARD_SPACING
	}
}

update_card_view_collisions :: proc(game: ^Game) {
	found := false
	#reverse for &cv in game.card_views {
		cv.collided = false
		if found { continue }

		card_rect := rl.Rectangle {
			cv.pos.x,
			cv.pos.y,
			f32(cv.texture.width) * CARD_SCALE,
			f32(cv.texture.height) * CARD_SCALE,
		}
		found = rl.CheckCollisionCircleRec(game.dot.current_pos, game.dot.size, card_rect)
		cv.collided = found
	}
}
