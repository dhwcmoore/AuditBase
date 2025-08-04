open Engine_interface

let test_boundary_classifier_integration () =
  Printf.printf "Testing BoundaryClassifier domain loading...\n";
  match Boundary_classifier.load_domain "boundary_logic/domain_definitions/diabetes.yaml" with
  | Ok _domain ->
      Printf.printf "✓ SUCCESS: Domain loaded successfully\n"
  | Error err ->
      Printf.printf "Current status: %s\n" err

let () = test_boundary_classifier_integration ()
