open Engine_interface

let test_diabetes () =
  Printf.printf "Testing diabetes.yaml...\n";
  match Domain_manager.load_domain "boundary_logic/domain_definitions/diabetes.yaml" with
  | Ok result ->
      Printf.printf "✓ SUCCESS: Loaded domain with %d boundaries\n"
        (List.length result.boundaries);
      Printf.printf "  Domain name: %s\n" result.name;
      Printf.printf "  Unit: %s\n" result.unit;
      let (lower, upper) = result.global_bounds in
      Printf.printf "  Global bounds: [%.1f, %.1f]\n" lower upper
  | Error err ->
      Printf.printf "✗ ERROR: %s\n" err

let () = test_diabetes ()
