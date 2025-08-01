let () = 
  match BoundaryClassifier.classify_from_yaml "working_system/domains/diabetes.yaml" "150" with
  | Ok result -> Printf.printf "Result: %s (confidence: %s)\n" result.category result.confidence
  | Error msg -> Printf.printf "Error: %s\n" msg
