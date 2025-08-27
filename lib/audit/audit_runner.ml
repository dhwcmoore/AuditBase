open Audit_types
open Audit_properties
open Audit_generators

let run_domain
  ~(spec:domain_spec)
  ~(classify:(float->string))
  : (string * bool list * (string * float) list) =
  let points = sample_points spec in
  let check_no_overlap x = no_overlap spec x in
  let check_coverage   x = coverage spec x in

  (* Monotonicity across adjacent sorted points *)
  let sorted = List.sort Float.compare points in
  let rec all_adj_monotone = function
    | [] | [_] -> true
    | x1 :: x2 :: xs ->
        monotone spec ~classify x1 x2 && all_adj_monotone (x2 :: xs)
  in
  let mono_ok = all_adj_monotone sorted in

  let failures =
    points
    |> List.filter (fun x -> not (check_no_overlap x && check_coverage x))
    |> List.map (fun x ->
        let kind = if not (check_no_overlap x) then "overlap" else "gap" in
        (kind, x))
  in
  (spec.name, [mono_ok], failures)
