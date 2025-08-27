open Audit_types

let eps = 1e-9

let clamp d x =
  if x < d.global_low then d.global_low
  else if x > d.global_high then d.global_high
  else x

let within d x =
  x > d.global_low -. 1e-12 && x < d.global_high +. 1e-12

let boundary_values (d:domain_spec) =
  (* all distinct interval endpoints *)
  let xs =
    List.concat_map (fun i -> [i.a; i.b]) d.intervals
    |> List.sort_uniq Float.compare
  in
  xs

let jitter_around d v =
  (* never probe exactly at v; nudge inside sides *)
  if v <= d.global_low +. 1e-15 then
    [d.global_low +. eps]
  else if v >= d.global_high -. 1e-15 then
    [d.global_high -. eps]
  else
    [v -. eps; v +. eps]

let interior_points (d:domain_spec) =
  List.filter_map (fun i ->
    let mid = (i.a +. i.b) /. 2. in
    if Float.is_finite mid then Some (clamp d mid) else None
  ) d.intervals

let sample_points (d:domain_spec) =
  let edge_samples =
    boundary_values d
    |> List.concat_map (jitter_around d)
  in
  let all = edge_samples @ interior_points d in
  all
  |> List.filter (within d)
  |> List.sort_uniq Float.compare
