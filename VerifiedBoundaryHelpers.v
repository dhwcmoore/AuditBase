(* File: VerifiedBoundaryHelpers.v
   Purpose: Verified helper functions and properties for boundary classification
*)

From Coq Require Import Reals List String Recdef.
From Coq Require Import Lra.
Import ListNotations.
Open Scope R_scope.

(* === Core Structures === *)
Record ClassBoundary := mkBoundary {
  lower : R;
  upper : R;
  category : string
}.

Definition ClassDomain := list ClassBoundary.

(* === Interval Membership === *)
Definition in_interval (x : R) (b : ClassBoundary) : Prop :=
  (lower b <= x < upper b)%R.

Example in_example :
  in_interval 3 (mkBoundary 1 5 "OK").
Proof.
  unfold in_interval. split; lra.
Qed.

(* === Adjacent Boundaries === *)
Definition adjacent (b1 b2 : ClassBoundary) : Prop :=
  upper b1 = lower b2.

Example adjacent_example :
  adjacent (mkBoundary 1 3 "A") (mkBoundary 3 5 "B").
Proof.
  unfold adjacent. reflexivity.
Qed.

(* === Sorted by Lower Bound (Well-Founded) === *)
Definition dom_length (d : ClassDomain) := length d.

Function sorted (dom : ClassDomain) {measure dom_length dom} : Prop :=
  match dom with
  | [] => True
  | [_] => True
  | b1 :: b2 :: rest =>
      (lower b1 <= lower b2)%R /\ sorted (b2 :: rest)
  end.
Proof.
  - intros. simpl. apply Lt.lt_n_Sn.
  - intros. simpl. apply Lt.lt_n_S. destruct rest; simpl; lia.
Defined.

Theorem sorted_example :
  sorted [mkBoundary 0 2 "A"; mkBoundary 2 5 "B"; mkBoundary 5 8 "C"].
Proof.
  simpl. split; lra. split; lra. trivial.
Qed.

(* === No Gaps Between Boundaries === *)
Function no_gaps (dom : ClassDomain) {measure dom_length dom} : Prop :=
  match dom with
  | [] => True
  | [_] => True
  | b1 :: b2 :: rest =>
      adjacent b1 b2 /\ no_gaps (b2 :: rest)
  end.
Proof.
  - intros. simpl. apply Lt.lt_n_Sn.
  - intros. simpl. apply Lt.lt_n_S. destruct rest; simpl; lia.
Defined.

Theorem no_gaps_example :
  no_gaps [mkBoundary 0 2 "A"; mkBoundary 2 5 "B"; mkBoundary 5 8 "C"].
Proof.
  simpl. split; reflexivity. split; reflexivity. trivial.
Qed.

(* === Coverage Predicate: Sorted ∧ No Gaps === *)
Definition full_coverage (dom : ClassDomain) : Prop :=
  sorted dom /\ no_gaps dom.

Theorem coverage_example :
  full_coverage [mkBoundary 0 2 "A"; mkBoundary 2 5 "B"; mkBoundary 5 8 "C"].
Proof.
  split.
  - apply sorted_example.
  - apply no_gaps_example.
Qed.
