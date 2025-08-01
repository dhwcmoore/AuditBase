let test_diabetes () =
  match Engine_interface__Domain_manager.load_domain "boundary_logic/domain_definitions/diabetes.yaml" with
  | Ok result ->
      Printf.printf "✓ SUCCESS: Loaded '%s' with %d boundaries\n"
        result.domain.name (List.length result.boundaries);
      Printf.printf "  Unit: %s\n" result.domain.unit;
      Printf.printf "  Global bounds: [%.1f, %.1f]\n" 
        (fst result.global_bounds) (snd result.global_bounds)
  | Error err ->
      Printf.printf "✗ ERROR: %s\n" (Engine_interface__Domain_manager.error_to_string err)

let () = test_diabetes ()
