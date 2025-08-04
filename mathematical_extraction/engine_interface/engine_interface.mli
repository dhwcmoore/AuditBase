(* Re-export modules for direct access *)
module Domain_manager : module type of Domain_manager.DomainManager

module Boundary_classifier : module type of Boundary_classifier.BoundaryClassifier

(* Engine_interface convenience types and functions *)
type boundary = Domain_manager.boundary
type domain = Domain_manager.domain
type classification_result = Boundary_classifier.classification_result

type coverage_report = {
  has_overlap : bool;
  has_gaps : bool;
  out_of_bounds : bool;
}

val classify : string -> float -> classification_result
val load_domain : string -> domain
val load_domain_from_file : string -> domain
val list_all_domains : unit -> string list
val analyze_coverage : domain -> coverage_report
val get_sample_value : domain -> float
