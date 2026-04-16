package main

import rl "vendor:raylib"

CardImages :: struct {
	cards: map[Card]rl.Texture2D,
}

card_images_init :: proc() -> CardImages {
	card_images := CardImages{}

	for card in STANDARD_DECK {
		card_code := card_get_code(card, context.temp_allocator)
		texture := rl.LoadTexture(rl.TextFormat("images/card-%s@3x.png", card_code))
		rl.SetTextureFilter(texture, .BILINEAR)
		card_images.cards[card] = texture
	}

	return card_images
}

card_images_destroy :: proc(card_images: ^CardImages) {
	for _, value in card_images.cards {
		rl.UnloadTexture(value)
	}

	delete(card_images.cards)
}
