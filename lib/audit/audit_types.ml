type interval = {
  a : float;
  b : float;
  left_closed : bool;
  right_closed : bool;
  category : string;
}

type domain_spec = {
  name : string;
  global_low : float;
  global_high : float;
  intervals : interval list;
  risk_order : string list option; (* e.g. ["Normal"; "Prediabetes"; "Diabetes"] *)
}
