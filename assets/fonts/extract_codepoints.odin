package fonts

import "core:fmt"
import "core:os/os2"
import "core:strings"


// Usage:
// 	make sure you have `otfinfo` installed and available in PATH
//	cd assets/fonts
font_path :: "ttyp016-uni.ttf" // Insert your font filename
include_codepoint_description :: false
output_file :: "extracted_codepoints_code.odin"
//	odin run .


main :: proc() {
	cmd := []string{"otfinfo", "-u", font_path}
	pd := os2.Process_Desc {
		command = cmd,
	}
	_, stdout, _, _ := os2.process_exec(pd, context.temp_allocator)
	codepoints := string(stdout)

	extracted_codepoints_code: strings.Builder
	fmt.sbprintln(
		&extracted_codepoints_code,
		`package fonts

// odinfmt: disable
font_codepoints :: []rune {`,
	)
	for codepoint_triple in strings.split_lines_iterator(&codepoints) {
		triple := strings.split_after_n(codepoint_triple, " ", 3)
		if include_codepoint_description {
			fmt.sbprint(&extracted_codepoints_code, triple[1], "/*", triple[0], triple[2], "*/", ", ")
		} else {
			fmt.sbprint(&extracted_codepoints_code, triple[1], ", ")
		}
	}
	fmt.sbprintln(&extracted_codepoints_code, `
}
// odinfmt: enable

`)

	output := strings.to_string(extracted_codepoints_code)
	_nvm := os2.write_entire_file("extracted_codepoints_code.odin", transmute([]u8)output)
}
