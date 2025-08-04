let run (domain_id : string) (show_boundaries : bool) : unit =
  let domain = Engine_interface.load_domain domain_id in
  Printf.printf "Domain Verification for %s:\n" domain_id;
  Printf.printf "  Name: %s\n" domain.name;
  Printf.printf "  Unit: %s\n" domain.unit;
  Printf.printf "  Boundary Count: %d\n" (List.length domain.boundaries);
  if show_boundaries then
    List.iteri (fun i (b : Engine_interface.boundary) ->
      Printf.printf "    - [%d] %s: %.2f → %.2f\n"
        i b.category b.lower b.upper
    ) domain.boundaries
