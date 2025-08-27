open Audit_types

let in_interval (i:interval) (x:float) : bool =
  let ge = if i.left_closed  then x >= i.a else x > i.a in
  let le = if i.right_closed then x <= i.b else x < i.b in
  ge && le

let within_bounds d x = x >= d.global_low && x <= d.global_high

(* No overlap: at most one interval matches any x *)
let no_overlap (d:domain_spec) (x:float) : bool =
  if not (within_bounds d x) then true
  else
    let matches = List.filter (fun i -> in_interval i x) d.intervals in
    List.length matches <= 1

(* Coverage: any x in [L,U] must belong to at least one interval *)
let coverage (d:domain_spec) (x:float) : bool =
  if not (within_bounds d x) then true
  else List.exists (fun i -> in_interval i x) d.intervals

(* Monotonicity: if a risk order exists, category rank must be nondecreasing as x increases *)
let monotone (d:domain_spec) ~(classify:(float->string)) (x1:float) (x2:float) : bool =
  match d.risk_order with
  | None -> true
  | Some order ->
    let idx c = match List.find_opt ((=) c) order with
      | None -> max_int
      | Some _ ->
        let rec pos k = function
          | [] -> max_int
          | h::t -> if h=c then k else pos (k+1) t
        in pos 0 order
    in
    if x1 <= x2 then idx (classify x1) <= idx (classify x2)
    else true
