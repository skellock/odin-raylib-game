package main

import rl "vendor:raylib"

CardImages :: struct {
	cards: map[Card]rl.Texture2D,
}

init_card_images :: proc() -> CardImages {
	card_images := CardImages{}

	for card in STANDARD_DECK {
		card_code := get_card_code(card, context.temp_allocator)
		texture := rl.LoadTexture(rl.TextFormat("images/card-%s@3x.png", card_code))
		rl.SetTextureFilter(texture, .BILINEAR)
		card_images.cards[card] = texture
	}

	return card_images
}

destroy_card_images :: proc(card_images: ^CardImages) {
	for _, value in card_images.cards {
		rl.UnloadTexture(value)
	}

	delete(card_images.cards)
}
