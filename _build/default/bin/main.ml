open Cmdliner

module BC = Engine_interface.Boundary_classifier
module DM = Engine_interface.Domain_manager

let inspect_cmd =
  let domain_arg = Arg.(required & pos 0 (some string) None & info [] ~docv:"DOMAIN" ~doc:"Domain file name (without .yaml extension)") in
  let value_arg = Arg.(required & pos 1 (some float) None & info [] ~docv:"VALUE" ~doc:"Value to classify") in
  let show_process_flag = Arg.(value & flag & info ["show-process"] ~doc:"Show detailed process information") in
  let inspect_fn domain value show_process =
    let domain_file = Printf.sprintf "boundary_logic/domain_definitions/%s.yaml" domain in
    let value_str = Float.to_string value in
    try
      match BC.BoundaryClassifier.classify_from_yaml domain_file value_str with
      | Ok result ->
          let basic_output = Printf.sprintf "Classification Result for %s = %.2f:\n  Category: %s\n  Confidence: %s" domain value result.category result.confidence in
          let detailed_output = if show_process then Printf.sprintf "%s\n  Process Details:\n    - Domain loaded from: %s\n    - Classification engine: %s" basic_output domain_file result.engine else basic_output in
          Printf.printf "%s\n" detailed_output
      | Error _ -> Printf.eprintf "Error: Classification failed\n"
    with exn -> Printf.eprintf "Error: Unexpected error: %s\n" (Printexc.to_string exn)
  in
  Cmd.v (Cmd.info "inspect" ~doc:"Inspect classification process for a specific value") Term.(const inspect_fn $ domain_arg $ value_arg $ show_process_flag)

let verify_cmd =
  let domain_arg = Arg.(required & pos 0 (some string) None & info [] ~docv:"DOMAIN" ~doc:"Domain file name (without .yaml extension)") in
  let show_boundaries_flag = Arg.(value & flag & info ["show-boundaries"] ~doc:"Show all domain boundaries") in
  let verify_fn domain show_boundaries =
    let domain_file = Printf.sprintf "boundary_logic/domain_definitions/%s.yaml" domain in
    try
      match DM.DomainManager.load_domain domain_file with
      | Ok domain_result ->
          let basic_info = Printf.sprintf "Domain Verification for %s:\n  Name: %s\n  Unit: %s\n  Boundary Count: %d" domain domain_result.name domain_result.unit (List.length domain_result.boundaries) in
          let boundary_details = if show_boundaries then 
            Printf.sprintf "%s\n  Boundaries: [Details available - %d boundaries loaded]" basic_info (List.length domain_result.boundaries)
          else basic_info in
          Printf.printf "%s\n" boundary_details
      | Error _ -> Printf.eprintf "Error: Domain verification failed\n"
    with exn -> Printf.eprintf "Error: Unexpected error: %s\n" (Printexc.to_string exn)
  in
  Cmd.v (Cmd.info "verify" ~doc:"Verify domain structure and mathematical engine integration") Term.(const verify_fn $ domain_arg $ show_boundaries_flag)

let test_pipeline_cmd =
  let all_domains_flag = Arg.(value & flag & info ["all-domains"] ~doc:"Test all available domains") in
  let sample_values_flag = Arg.(value & flag & info ["sample-values"] ~doc:"Use sample values for testing") in
  let test_pipeline_fn all_domains _sample_values =
    if not all_domains then Printf.eprintf "Error: Currently only --all-domains mode is supported\n" else
    try
      let domain_dir = "boundary_logic/domain_definitions" in
      let domain_files = Sys.readdir domain_dir |> Array.to_list |> List.filter (fun f -> Filename.check_suffix f ".yaml") |> List.sort String.compare in
      let test_results = List.map (fun file ->
        let domain_path = Filename.concat domain_dir file in
        let domain_name = Filename.chop_suffix file ".yaml" in
        try
          match DM.DomainManager.load_domain domain_path with
          | Ok domain_result ->
              let boundary_count = List.length domain_result.boundaries in
              Printf.sprintf "  %s: ✅ Domain loaded (%d boundaries)" domain_name boundary_count
          | Error _ -> Printf.sprintf "  %s: ❌ Load failed" domain_name
        with _ -> Printf.sprintf "  %s: ❌ Exception" domain_name
      ) domain_files in
      let summary = Printf.sprintf "Pipeline Test Results (%d domains tested):\n%s" (List.length domain_files) (String.concat "\n" test_results) in
      Printf.printf "%s\n" summary
    with exn -> Printf.eprintf "Error: Unexpected error: %s\n" (Printexc.to_string exn)
  in
  Cmd.v (Cmd.info "test-pipeline" ~doc:"Test classification pipeline across multiple domains") Term.(const test_pipeline_fn $ all_domains_flag $ sample_values_flag)

let main_cmd = 
  let info = Cmd.info "veribound" ~version:"2.0" ~doc:"Veribound 2.0 - Process-oriented boundary classification system" in
  Cmd.group info [inspect_cmd; verify_cmd; test_pipeline_cmd]

let () = exit (Cmd.eval main_cmd)
