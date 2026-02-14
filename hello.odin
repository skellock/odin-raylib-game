package main

import rl "vendor:raylib"

state := GameState{}

main :: proc() {
	rl.InitWindow(1024, 768, "OdinRaylib")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		update()
		draw()
	}
}

update :: proc() {
	mx := rl.GetMouseX()
	state.big = mx < rl.GetScreenWidth() / 2
}

draw :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	x := rl.GetScreenWidth() / 2
	rl.DrawRectangle(0, 0, x, rl.GetScreenHeight(), rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, rl.GetScreenHeight(), rl.ColorAlpha(rl.WHITE, 0.5))

	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)

	pos := rl.GetMousePosition()

	rl.DrawCircle(i32(pos.x), i32(pos.y), state.big ? 20 : 10, rl.YELLOW)

	draw_debug()
}
