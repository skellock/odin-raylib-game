package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

SAVE_FILENAME :: "game.json"

SaveGame :: struct {
	cards:     [52]Card,
	dot_x:     f32,
	dot_y:     f32,
	dot_color: DotColor,
}

save_game_init :: proc(game: Game) -> SaveGame {
	return SaveGame {
		cards = game.deck.cards,
		dot_x = game.dot.current_pos[0],
		dot_y = game.dot.current_pos[1],
		dot_color = game.dot.color,
	}
}

save_game_read :: proc() -> (SaveGame, bool) {
	// read the save game file
	data, read_err := os.read_entire_file(SAVE_FILENAME, context.allocator)
	if read_err != nil {
		fmt.eprintfln("Failed to load file %v %v", SAVE_FILENAME, read_err)
		return {}, false
	}
	defer delete(data)

	// deserialize it
	save: SaveGame
	unmarshal_err := json.unmarshal(data, &save)
	if unmarshal_err != nil {
		fmt.eprintfln("Failed to unmarshal the file: %v", unmarshal_err)
		return {}, false
	}

	return save, true
}

save_game_write :: proc(self: SaveGame) {
	// serialize it to JSON
	json_data, err := json.marshal(self, {pretty = true, use_enum_names = true})
	if err != nil {
		fmt.eprintln("Unable to marshal JSON: %v", err)
		return
	}
	defer delete(json_data)

	// save it to the filesystem
	write_err := os.write_entire_file(SAVE_FILENAME, json_data)
	if write_err != nil {
		fmt.eprintln("Unable to save file: %v %v", SAVE_FILENAME, write_err)
		return
	}
}

save_game_restore :: proc(self: SaveGame, game: ^Game) {
	game.deck.cards = self.cards
	game.dot.current_pos = {self.dot_x, self.dot_y}
	game.dot.color = self.dot_color

	// update dependent game state
	dot_clear_tweens(&game.dot)
	game_deal_to_hand(game)
}
