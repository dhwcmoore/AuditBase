open Engine_interface

let debug_final_boundaries filename =
  match Domain_manager.load_domain filename with
  | Ok result ->
      Printf.printf "Loaded domain successfully\n";
      Printf.printf "Boundaries count: %d\n" (List.length result.boundaries);
      (* Check if we can access the first boundary *)
      (match result.boundaries with
       | [] -> Printf.printf "No boundaries\n"
       | _first :: _ -> 
           Printf.printf "First boundary exists\n"
      )
  | Error err ->
      Printf.printf "Error: %s\n" err

let () = debug_final_boundaries "boundary_logic/domain_definitions/blood_pressure.yaml"
