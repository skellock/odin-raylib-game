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

load_save_game :: proc(game: ^Game) {
	// read the save game file
	data, read_err := os.read_entire_file(SAVE_FILENAME, context.allocator)
	if read_err != nil {
		fmt.eprintfln("Failed to load file %v %v", SAVE_FILENAME, read_err)
		return
	}
	defer delete(data)

	// deserialize it
	save: SaveGame
	unmarshal_err := json.unmarshal(data, &save)
	if unmarshal_err != nil {
		fmt.eprintfln("Failed to unmarshal the file: %v", unmarshal_err)
		return
	}

	// populate the Game with the SaveGame data
	restore_save_game(game, &save)
}

write_save_game :: proc(game: ^Game) {
	// construct a SaveGame
	save := build_save_game(game)

	// serialize it to JSON
	json_data, err := json.marshal(save, {pretty = true, use_enum_names = true})
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
