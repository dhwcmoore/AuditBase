open Engine_interface

let () = 
  let test_file = "boundary_logic/domain_definitions/diabetes.yaml" in
  Printf.printf "Testing BoundaryClassifier conversion and classification...\n";
  match Boundary_classifier.BoundaryClassifier.classify_from_yaml test_file "150" with
  | Ok result -> 
    Printf.printf "✅ SUCCESS!\n";
    Printf.printf "Input: 150\n";
    Printf.printf "Category: %s\n" result.category;
    Printf.printf "Confidence: %s\n" result.confidence;
    Printf.printf "Engine: %s\n" result.engine
  | Error msg -> 
    Printf.printf "❌ Error: %s\n" msg
