open Engine_interface

let test_boundaries () =
  Printf.printf "Reading file directly...\n";
  let content = 
    let ic = open_in "../boundary_logic/domain_definitions/diabetes.yaml" in
    let content = really_input_string ic (in_channel_length ic) in
    close_in ic; content in
  
  Printf.printf "File content:\n%s\n" content;
  Printf.printf "===================\n";
  
  (* Test the parsing *)
  match Domain_manager.DomainManager.load_domain "../boundary_logic/domain_definitions/diabetes.yaml" with
  | Ok result ->
      Printf.printf "Domain loaded but boundaries count: %d\n" (List.length result.boundaries)
  | Error err ->
      Printf.printf "Error: %s\n" err

let () = test_boundaries ()
