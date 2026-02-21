package main

import rl "vendor:raylib"

CardImages :: struct {
	qh: rl.Texture2D,
	ac: rl.Texture2D,
}


init_card_images :: proc() -> CardImages {
	return CardImages {
		qh = rl.LoadTexture("images/card-qh.png"),
		ac = rl.LoadTexture("images/card-ac.png"),
	}
}

destroy_card_images :: proc(card_images: ^CardImages) {
	rl.UnloadTexture(card_images.qh)
	rl.UnloadTexture(card_images.ac)
}
