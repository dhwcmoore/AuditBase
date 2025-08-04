(* test/test_overlap_check.ml *)

open Engine_interface

type boundary_issue = 
  | Overlap of float * float
  | Gap of float * float  
  | OutOfGlobalBounds of float * float

let string_of_issue = function
  | Overlap (l, u) -> Printf.sprintf "[Overlap] %.2f – %.2f" l u
  | Gap (l, u) -> Printf.sprintf "[Gap] %.2f – %.2f" l u
  | OutOfGlobalBounds (l, u) -> Printf.sprintf "[OutOfGlobalBounds] %.2f – %.2f" l u

let extract_ranges (boundaries : Domain_manager.boundary list) =
  List.map (fun (boundary : Domain_manager.boundary) -> 
    (boundary.lower, boundary.upper)
  ) boundaries
  |> List.sort (fun (l1, _) (l2, _) -> Float.compare l1 l2)

let detect_overlaps ranges =
  let rec check_pairs acc = function
    | [] | [_] -> acc
    | (_, u1) :: (l2, u2) :: rest ->
        if u1 > l2 then
          check_pairs (Overlap (l2, u1) :: acc) ((l2, u2) :: rest)
        else
          check_pairs acc ((l2, u2) :: rest)
  in
  check_pairs [] ranges

let detect_gaps ranges =
  let rec check_gaps acc = function
    | [] | [_] -> acc
    | (_, u1) :: (l2, u2) :: rest ->
        if u1 < l2 then
          check_gaps (Gap (u1, l2) :: acc) ((l2, u2) :: rest)
        else
          check_gaps acc ((l2, u2) :: rest)
  in
  check_gaps [] ranges

let check_global_bounds ranges (global_min, global_max) =
  List.fold_left (fun acc (l, u) ->
    let issues = [] in
    let issues = if l < global_min then OutOfGlobalBounds (l, global_min) :: issues else issues in
    let issues = if u > global_max then OutOfGlobalBounds (global_max, u) :: issues else issues in
    issues @ acc
  ) [] ranges

let analyze_boundaries boundaries global_bounds =
  let ranges = extract_ranges boundaries in
  let overlaps = detect_overlaps ranges in
  let gaps = detect_gaps ranges in
  let global_issues = check_global_bounds ranges global_bounds in
  overlaps @ gaps @ global_issues

let run_test file =
  match Domain_manager.load_domain file with
  | Error err ->
      Printf.printf "Failed to load domain file: %s\n" file;
      Printf.printf "  Error: %s\n" err
  | Ok domain ->
      Printf.printf "✓ Domain loaded: %s\n" domain.name;
      Printf.printf "  Analyzing %d boundaries...\n" (List.length domain.boundaries);
      
      let issues = analyze_boundaries domain.boundaries domain.global_bounds in
      
      if List.length issues = 0 then
        Printf.printf "  ✅ No boundary issues found - perfect coverage!\n"
      else (
        Printf.printf "  ⚠️ Found %d issues:\n" (List.length issues);        
        List.iter (fun issue -> Printf.printf "    %s\n" (string_of_issue issue)) issues
      )

     let find_coverage_issues boundaries global_bounds =
  analyze_boundaries boundaries global_bounds
 