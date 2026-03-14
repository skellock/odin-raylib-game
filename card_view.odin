package main

import rl "vendor:raylib"

CARD_SCALE :: f32(1.0 / 3.0)
CARD_SPACING :: rl.Vector2{25, 0}

CardView :: struct {
	card:    Card,
	pos:     rl.Vector2,
	texture: rl.Texture2D,
}

init_card_view :: proc(card: Card, texture: rl.Texture2D) -> CardView {
	return CardView{card = card, texture = texture}
}

update_card_view_positions :: proc(hand: []CardView) {
	pos := rl.Vector2{200, 200}
	for idx in 0 ..< len(hand) {
		hand[idx].pos = pos
		pos += CARD_SPACING
	}
}
