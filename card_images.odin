package main

import rl "vendor:raylib"

CardImages :: struct {
	cards: map[string]rl.Texture2D,
}

CARD_NAMES := [52]string {
	"2c",
	"3c",
	"4c",
	"5c",
	"6c",
	"7c",
	"8c",
	"9c",
	"tc",
	"jc",
	"qc",
	"kc",
	"ac",
	"2h",
	"3h",
	"4h",
	"5h",
	"6h",
	"7h",
	"8h",
	"9h",
	"th",
	"jh",
	"qh",
	"kh",
	"ah",
	"2s",
	"3s",
	"4s",
	"5s",
	"6s",
	"7s",
	"8s",
	"9s",
	"ts",
	"js",
	"qs",
	"ks",
	"as",
	"2d",
	"3d",
	"4d",
	"5d",
	"6d",
	"7d",
	"8d",
	"9d",
	"td",
	"jd",
	"qd",
	"kd",
	"ad",
}

init_card_images :: proc() -> CardImages {
	cards := make(map[string]rl.Texture2D)

	for card_name in CARD_NAMES {
		cards[card_name] = rl.LoadTexture(rl.TextFormat("images/card-%s.png", card_name))
	}

	return CardImages{cards = cards}
}

destroy_card_images :: proc(card_images: ^CardImages) {
	for _, value in card_images.cards {
		rl.UnloadTexture(value)
	}

	delete(card_images.cards)
}
