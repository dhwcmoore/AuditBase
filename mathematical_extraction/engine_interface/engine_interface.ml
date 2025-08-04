(* Re-export modules for external access *)
module Domain_manager = Domain_manager.DomainManager
module Boundary_classifier = Boundary_classifier.BoundaryClassifier

(* Type aliases for convenience - using the actual types from modules *)
type boundary = Domain_manager.boundary
type domain = Domain_manager.domain  
type classification_result = Boundary_classifier.classification_result

type coverage_report = {
  has_overlap : bool;
  has_gaps : bool;
  out_of_bounds : bool;
}

let classify domain_id value =
  let yaml = Printf.sprintf "boundary_logic/domain_definitions/%s.yaml" domain_id in
  match Boundary_classifier.classify_from_yaml yaml (string_of_float value) with
  | Ok result -> result
  | Error msg ->
      Printf.eprintf "Classification error: %s\n" msg;
      exit 1

let load_domain domain_id =
  let yaml = Printf.sprintf "boundary_logic/domain_definitions/%s.yaml" domain_id in
  match Domain_manager.load_domain yaml with
  | Ok domain -> domain
  | Error msg ->
      Printf.eprintf "Load error: %s\n" msg;
      exit 1

let load_domain_from_file yaml =
  match Domain_manager.load_domain yaml with
  | Ok domain -> domain
  | Error msg ->
      Printf.eprintf "Load error: %s\n" msg;
      exit 1

let list_all_domains () =
  let dir = "boundary_logic/domain_definitions/" in
  Sys.readdir dir
  |> Array.to_list
  |> List.filter (fun f -> Filename.extension f = ".yaml")
  |> List.map (Filename.remove_extension)

(* Simple coverage analysis using Domain_manager types directly *)
let analyze_coverage (domain : domain) : coverage_report =
  let sorted_boundaries = List.sort (fun (a : Domain_manager.boundary) (b : Domain_manager.boundary) -> 
    Float.compare a.lower b.lower) domain.boundaries in
  let has_overlap = ref false in
  let has_gaps = ref false in
  
  (* Check for overlaps *)
  List.iteri (fun i (boundary : Domain_manager.boundary) ->
    if i > 0 then
      let prev = List.nth sorted_boundaries (i-1) in
      if prev.upper > boundary.lower then
        has_overlap := true
  ) sorted_boundaries;
  
  (* Check for gaps *)
  List.iteri (fun i (boundary : Domain_manager.boundary) ->
    if i > 0 then
      let prev = List.nth sorted_boundaries (i-1) in
      if prev.upper < boundary.lower then
        has_gaps := true
  ) sorted_boundaries;
  
  let (global_lower, global_upper) = domain.global_bounds in
  let out_of_bounds = List.exists (fun (b : Domain_manager.boundary) -> 
    b.lower < global_lower || b.upper > global_upper
  ) domain.boundaries in
  
  {
    has_overlap = !has_overlap;
    has_gaps = !has_gaps;
    out_of_bounds = out_of_bounds;
  }

let get_sample_value (_domain : domain) = 42.0
