let run (all_domains : bool) (sample_values : bool) : unit =
  let domains = if all_domains then Engine_interface.list_all_domains () else [] in
  let tested = ref 0 in
  List.iter (fun domain_id ->
    let domain = Engine_interface.load_domain domain_id in
    let b_count = List.length domain.boundaries in
    Printf.printf "  %s: ✅ Domain loaded (%d boundaries)\n" domain_id b_count;
    if sample_values then (
      let test_val = Engine_interface.get_sample_value domain in
      let result = Engine_interface.classify domain_id test_val in
      Printf.printf "    → Sample %.2f → %s\n" test_val result.category
    );
    tested := !tested + 1
  ) domains;
  Printf.printf "Pipeline Test Results (%d domains tested).\n" !tested
