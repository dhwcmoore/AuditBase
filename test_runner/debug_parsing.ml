let debug_range_parsing filename =
  Printf.printf "\nDebugging: %s\n" filename;
  let content = 
    let ic = open_in filename in
    let content = really_input_string ic (in_channel_length ic) in
    close_in ic; content in
  
  let lines = String.split_on_char '\n' content in
  let lines = List.map String.trim lines in
  
  (* Find boundary lines *)
  List.iteri (fun i line ->
    if String.starts_with ~prefix:"- range:" line then
      Printf.printf "Line %d: '%s' (length=%d)\n" i line (String.length line);
      if String.length line > 9 then (
        let range_part = String.sub line 9 (String.length line - 9) in
        Printf.printf "  range_part: '%s'\n" range_part;
        let range_part = String.trim range_part in
        Printf.printf "  trimmed: '%s'\n" range_part;
        let range_part = String.map (function '[' | ']' -> ' ' | c -> c) range_part in
        Printf.printf "  no brackets: '%s'\n" range_part;
        let range_nums = String.split_on_char ',' range_part in
        Printf.printf "  split: [%s]\n" (String.concat "; " (List.map (fun s -> "'" ^ s ^ "'") range_nums));
        try
          let lower = Float.of_string (String.trim (List.hd range_nums)) in
          let upper = Float.of_string (String.trim (List.nth range_nums 1)) in
          Printf.printf "  parsed: lower=%f, upper=%f, valid=%b\n" lower upper (lower < upper)
        with exn ->
          Printf.printf "  parsing failed: %s\n" (Printexc.to_string exn)
      ) else Printf.printf "  line too short\n"
  ) lines

let () = debug_range_parsing "boundary_logic/domain_definitions/blood_pressure.yaml"
