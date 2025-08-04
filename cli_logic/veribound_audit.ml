let run (file_path : string) (coverage : bool) : unit =
  let domain = Engine_interface.load_domain_from_file file_path in
  Printf.printf "Auditing domain: %s\n" file_path;
  Printf.printf "  Boundary count: %d\n" (List.length domain.boundaries);
  if coverage then (
    let report = Engine_interface.analyze_coverage domain in
    if report.has_overlap then Printf.printf "  ❌ Overlaps detected.\n";
    if report.has_gaps then Printf.printf "  ❌ Gaps detected.\n";
    if report.out_of_bounds then Printf.printf "  ❌ Out-of-bounds entries.\n";
    if not (report.has_overlap || report.has_gaps || report.out_of_bounds) then
      Printf.printf "  ✅ No coverage issues found.\n"
  )
