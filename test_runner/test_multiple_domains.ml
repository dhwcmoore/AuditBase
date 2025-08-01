open Engine_interface

let test_domain filename =
  Printf.printf "\nTesting: %s\n" (Filename.basename filename);
  match Domain_manager.DomainManager.load_domain filename with
  | Ok result ->
      Printf.printf "✓ SUCCESS: %d boundaries\n" (List.length result.boundaries);
      Printf.printf "  Name: %s\n" result.name;
      Printf.printf "  Unit: %s\n" result.unit
  | Error err ->
      Printf.printf "✗ ERROR: %s\n" err

let () = 
  test_domain "../boundary_logic/domain_definitions/diabetes.yaml";
  test_domain "../boundary_logic/domain_definitions/blood_pressure.yaml";
  test_domain "../boundary_logic/domain_definitions/basel_iii_capital_adequacy.yaml"
