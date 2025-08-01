(* test_runner/test_overlap_check.ml *)

open Test_support

(* This executable just runs the test function from the Check_overlap_and_coverage module *)
let () =
  let test_file = 
    if Array.length Sys.argv > 1 then 
      Sys.argv.(1) 
    else 
      "boundary_logic/domain_definitions/aqi.yaml" 
  in
  Check_overlap_and_coverage.run_test test_file
