package main

import rl "vendor:raylib"

header_font_data :: #load("assets/fonts/Adventure12x24.ttf", []u8)
header_font_size :: 24
body_font_data :: #load("assets/fonts/ttyp016-uni.ttf", []u8)
body_font_size :: 16

WINDOW_MINIMUM_WIDTH :: 480
WINDOW_MINIMUM_HEIGHT :: 480

Game :: struct {
	window_width:  i32,
	window_height: i32,
	title:         cstring,
	header_font:   rl.Font,
	body_font:     rl.Font,
	key_bindings:  struct {
		close_game: rl.KeyboardKey,
	},
}

main :: proc() {
	game := Game {
		window_width = 600,
		window_height = 600,
		title = "Font baking example in Odin & Raylib",
		key_bindings = {close_game = .ESCAPE},
	}


	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(game.window_width, game.window_height, game.title)
	defer rl.CloseWindow()
	rl.SetWindowMinSize(WINDOW_MINIMUM_WIDTH, WINDOW_MINIMUM_HEIGHT)
	rl.SetExitKey(game.key_bindings.close_game)
	rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))

	load_fonts(&game)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({255, 107, 142, 35})

		rl.DrawTextEx(
			game.body_font,
			"Meine freunde",
			{60, 90},
			f32(game.body_font.baseSize) * 3,
			0,
			{255, 255, 255, 255},
		)

		rl.DrawTextEx(
			game.body_font,
			`
                  ..
                 /  \.
               .'...  \.
             .'.. .   ..\
            /. . . .   ..\.
           /...  ... .    .\
          /.. . ........   .\
        .'.   ...   ......  .|
      .' ... . ..... . ..--'.|
    .' ...  ...   ._.--'    .|
  .'... . ...  _.-'O   OO O .|
 /... .___.---'O OO .O. OO O.|
/__.--' OO O  .OO O  OO O ...|
| OO OO O OO . .O. OO O  ..O.|
(O. OO. .O O O O  OO  ..OO O.|
( OO .O. O  O  OO............|
(OOO........O_______.-------'
|_____.-----'
`,
			{300, 70},
			f32(game.body_font.baseSize),
			0,
			{255, 245, 233, 255},
		)

		rl.DrawTextEx(
			game.header_font,
			"We got baked!",
			{50, 430},
			f32(game.header_font.baseSize) * 3,
			0,
			{255, 255, 255, 255},
		)

		rl.EndDrawing()
	}
}

load_fonts :: proc(game: ^Game) {
	game.header_font = load_font(header_font_data, header_font_size)
	assert(rl.IsFontValid(game.header_font), "Header font is not valid")
	assert(game.header_font.baseSize != 0, "Header font loading failed")

	game.body_font = load_font(body_font_data, body_font_size)
	assert(rl.IsFontValid(game.body_font), "Body font is not valid")
	assert(game.body_font.baseSize != 0, "Body font loading failed")
}

load_font :: proc(
	file_data: []u8,
	font_size: int,
	codepoints: [^]rune = nil,
	codepoint_count: int = 0,
) -> rl.Font {
	return rl.LoadFontFromMemory(
		fileType = ".ttf",
		fileData = &file_data[0],
		dataSize = i32(len(file_data)),
		fontSize = i32(font_size),
		codepoints = codepoints,
		codepointCount = i32(codepoint_count),
	)
}
