let run (domain_id : string) (value : float) (show_process : bool) : unit =
  let result = Engine_interface.classify domain_id value in
  Printf.printf "Classification Result for %s = %.2f:\n" domain_id value;
  Printf.printf "  Category: %s\n" result.category;
  Printf.printf "  Confidence: %s\n" result.confidence;
  if show_process then (
    Printf.printf "  Process Details:\n";
    Printf.printf "    - Domain loaded from: %s\n" result.input_value;
    Printf.printf "    - Classification engine: %s\n" result.engine;
  )
