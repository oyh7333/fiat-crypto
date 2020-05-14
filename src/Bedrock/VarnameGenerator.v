Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
Require Import Crypto.Util.Strings.Decimal.
Require Import Crypto.Util.Tactics.BreakMatch.
Require Import Crypto.Util.Strings.String.
Local Open Scope string_scope.

(* TODO: move this? *)
Lemma append_eq_r_iff s1 s2 s3 :
  s1 ++ s2 = s1 ++ s3 <-> s2 = s3.
Proof.
  induction s1; cbn [append]; split;
    try inversion 1; intros; auto; [ ].
  apply IHs1. auto.
Qed.

(* TODO: move this? *)
Lemma append_eq_prefix :
  forall s1 s2 s3 s4,
    s1 ++ s2 = s3 ++ s4 ->
    prefix s1 s3 = true \/ prefix s3 s1 = true.
Proof.
  induction s1; destruct s3; cbn [append prefix] in *;
    intros; try tauto; [ ].
  match goal with H : String _ _ = String _ _ |- _ =>
                  inversion H; clear H; subst end.
  break_match; subst; try tauto.
  eapply IHs1; eauto.
Qed.

Section prefix_generator.
  Context (pre : string).

  Definition prefix_name_gen (x : nat) : string :=
    pre ++ Z.to_string (Z.of_nat x).

  Lemma prefix_name_gen_unique i j :
    prefix_name_gen i = prefix_name_gen j <-> i = j.
  Proof.
    intros.
    pose proof (Decimal.Z.of_to (Z.of_nat i)).
    pose proof (Decimal.Z.of_to (Z.of_nat j)).
    split; intros; [ | subst; reflexivity ].
    match goal with H : _ |- _ => apply append_eq_r_iff in H end.
    apply Nat2Z.inj. congruence.
  Qed.

  Lemma prefix_name_gen_prefix i :
    prefix pre (prefix_name_gen i) = true.
  Proof.
    apply prefix_correct.
    cbv [prefix_name_gen]; induction pre; intros.
    { cbn [length]. apply substring_0_0. }
    { cbn. congruence. }
  Qed.

  Lemma prefix_name_gen_startswith v i :
    v = prefix_name_gen i ->
    startswith pre v = true.
  Proof.
    intros; subst. cbv [startswith].
    apply eqb_eq. symmetry. apply prefix_correct.
    apply prefix_name_gen_prefix.
  Qed.
End prefix_generator.

Section disjoint.
  Definition disjoint (gen1 gen2 : nat -> string) : Prop :=
    forall n m, gen1 n <> gen2 m.

  Lemma prefix_generator_disjoint pre1 pre2 :
    prefix pre1 pre2 = false ->
    prefix pre2 pre1 = false ->
    disjoint (prefix_name_gen pre1) (prefix_name_gen pre2).
  Proof.
    cbv [disjoint prefix_name_gen]; intros.
    let H := fresh in
    intro H; apply append_eq_prefix in H; destruct H;
      congruence.
  Qed.
End disjoint.

Section defaults.
  Definition default_inname_gen : nat -> string :=
    prefix_name_gen "in".
  Definition default_outname_gen : nat -> string :=
    prefix_name_gen "out".
  Definition default_varname_gen : nat -> string :=
    prefix_name_gen "x".

  Lemma outname_gen_inname_gen_disjoint :
    disjoint default_outname_gen default_inname_gen.
  Proof. apply prefix_generator_disjoint; reflexivity. Qed.
  Lemma inname_gen_varname_gen_disjoint :
    disjoint default_inname_gen default_varname_gen.
  Proof. apply prefix_generator_disjoint; reflexivity. Qed.
  Lemma outname_gen_varname_gen_disjoint :
    disjoint default_outname_gen default_varname_gen.
  Proof. apply prefix_generator_disjoint; reflexivity. Qed.
End defaults.
