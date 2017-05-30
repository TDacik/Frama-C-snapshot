(**************************************************************************)
(*                                                                        *)
(*  This file is part of WP plug-in of Frama-C.                           *)
(*                                                                        *)
(*  Copyright (C) 2007-2017                                               *)
(*    CEA (Commissariat a l'energie atomique et aux energies              *)
(*         alternatives)                                                  *)
(*                                                                        *)
(*  you can redistribute it and/or modify it under the terms of the GNU   *)
(*  Lesser General Public License as published by the Free Software       *)
(*  Foundation, version 2.1.                                              *)
(*                                                                        *)
(*  It is distributed in the hope that it will be useful,                 *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Lesser General Public License for more details.                   *)
(*                                                                        *)
(*  See the GNU Lesser General Public License version 2.1                 *)
(*  for more details (enclosed in the file licenses/LGPLv2.1).            *)
(*                                                                        *)
(**************************************************************************)

(* This file is generated by Why3's Coq-realize driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require BuiltIn.
Require int.Int.
Require int.Abs.
Require int.ComputerDivision.

(* ---------------------------------------------------------------------- *)
(* --- Lists for Why-3                                                --- *)
(* ---------------------------------------------------------------------- *)

Require List.
Ltac seq := autorewrite with list ; auto with zarith.
Hint Rewrite List.app_assoc List.app_nil_l List.app_nil_r : list.

  (* -------------------------------------------------------------------- *)
  (* --- Classical Lists for Alt-Ergo                                 --- *)
  (* -------------------------------------------------------------------- *)
Require Import Qedlib.

(* Why3 goal *)
Definition list : forall (a:Type), Type.
  exact(List.list).
Defined.

(* Why3 goal *)
Definition nil: forall {a:Type} {a_WT:WhyType a}, (list a).
  intros a a_WT.
  generalize a.
  exact(@List.nil).
Defined.

(* Why3 goal *)
Definition cons: forall {a:Type} {a_WT:WhyType a}, a -> (list a) -> (list a).
  intros a a_WT.
  generalize a.
  exact(@List.cons).
Defined.

(* Why3 goal *)
Definition concat: forall {a:Type} {a_WT:WhyType a}, (list a) -> (list a) ->
  (list a).
  intros a a_WT.
  Open Local Scope list_scope.
  exact(fun u v => u ++ v).
Defined.

Fixpoint repeat_nat (a:Type) (w: list a) (n: nat) {struct n} :=
    match n with
      | O => w
      | S m => w ++ (repeat_nat a w m)
    end.

		 
(* Why3 goal *)
Definition repeat: forall {a:Type} {a_WT:WhyType a}, (list a) -> Z -> (list
  a).
  intros a a_WT.
  exact(fun w n  => match n with
                   | Z0 => nil
                   | Zneg _ => nil
                   | other => repeat_nat a w (Zabs_nat (n-1))
                   end).
Defined.

(* Why3 goal *)
Definition length: forall {a:Type} {a_WT:WhyType a}, (list a) -> Z.
  intros a a_WT.
  exact(fun w => Z.of_nat (List.length w)).
Defined.

(* Why3 goal *)
Definition nth: forall {a:Type} {a_WT:WhyType a}, (list a) -> Z -> a.
 intros a a_WT.
  exact(fun w n => match n with
                   | Zneg _ => (@why_inhabitant a a_WT)
                   | other => List.nth (Zabs_nat n) w (@why_inhabitant a a_WT)
                   end).
Defined.

  (* -------------------------------------------------------------------- *)
  (* --- length                                                       --- *)
  (* -------------------------------------------------------------------- *)

(* Why3 goal *)
Lemma length_pos : forall {a:Type} {a_WT:WhyType a}, forall (w:(list a)),
  (0%Z <= (length w))%Z.
Proof.
  intros.
  unfold length. 
  apply Zle_0_nat.
Qed.

(* Why3 goal *)
Lemma length_nil : forall {a:Type} {a_WT:WhyType a}, ((length (nil : (list
  a))) = 0%Z).
Proof.
  intros.
  unfold length. unfold nil.
  by seq.
Qed.

(* Why3 goal *)
Lemma length_nil_bis : forall {a:Type} {a_WT:WhyType a}, forall (w:(list a)),
  ((length w) = 0%Z) -> (w = (nil : (list a))).
Proof.
  intros a a_WT w.
  unfold length. unfold nil.
  destruct w.
  + by seq.
  + Import List.ListNotations.
    assert (0 < Z.of_nat (Datatypes.length (a0 :: w))).
    { replace (Datatypes.length (a0 :: w)) with (1 + Datatypes.length (w))%nat
        by( (replace (a0 :: w) with ([a0] ++ w) by seq); rewrite List.app_length; by seq).
      assert (0 <= Z.of_nat (Datatypes.length w)) by apply Zle_0_nat.
      replace (Z.of_nat (1 + Datatypes.length w)) with (1 + Z.of_nat (Datatypes.length w)).
      { omega. }
      rewrite Nat2Z.inj_add. 
      auto with zarith. 
    }
    intro. 
    cut False; [contradiction|omega].
Qed.

(* Why3 goal *)
Hypothesis length_cons : forall {a:Type} {a_WT:WhyType a}, forall (x:a)
  (w:(list a)), ((length (cons x w)) = (1%Z + (length w))%Z).

(* Why3 goal *)
Hypothesis length_concat : forall {a:Type} {a_WT:WhyType a}, forall (u:(list
  a)) (v:(list a)), ((length (concat u v)) = ((length u) + (length v))%Z).

(* Why3 goal *)
Hypothesis length_repeat : forall {a:Type} {a_WT:WhyType a}, forall (w:(list
  a)) (n:Z), (0%Z <= n)%Z -> ((length (repeat w n)) = (n * (length w))%Z).

  (* -------------------------------------------------------------------- *)
  (* --- nth                                                          --- *)
  (* -------------------------------------------------------------------- *)

(* Why3 goal *)
Hypothesis nth_cons : forall {a:Type} {a_WT:WhyType a}, forall (k:Z) (x:a)
  (w:(list a)), ((k = 0%Z) -> ((nth (cons x w) k) = x)) /\ ((~ (k = 0%Z)) ->
  ((nth (cons x w) k) = (nth w (k - 1%Z)%Z))).

(* Why3 goal *)
Hypothesis nth_concat : forall {a:Type} {a_WT:WhyType a}, forall (u:(list a))
  (v:(list a)) (k:Z), ((k < (length u))%Z -> ((nth (concat u v) k) = (nth u
  k))) /\ ((~ (k < (length u))%Z) -> ((nth (concat u v) k) = (nth v
  (k - (length u))%Z))).

(* Why3 goal *)
Hypothesis nth_repeat : forall {a:Type} {a_WT:WhyType a}, forall (n:Z) (k:Z)
  (w:(list a)), ((0%Z <= k)%Z /\ (k < (n * (length w))%Z)%Z) ->
  ((0%Z < (length w))%Z -> ((nth (repeat w n) k) = (nth w
  (ZArith.BinInt.Z.rem k (length w))))).

(* Why3 assumption *)
Definition vlist_eq {a:Type} {a_WT:WhyType a} (u:(list a)) (v:(list
  a)): Prop := ((length u) = (length v)) /\ forall (i:Z), ((0%Z <= i)%Z /\
  (i < (length u))%Z) -> ((nth u i) = (nth v i)).

  (* -------------------------------------------------------------------- *)
  (* --- equality of Lists                                            --- *)
  (* -------------------------------------------------------------------- *)

(* Why3 goal *)
Hypothesis extensionality : forall {a:Type} {a_WT:WhyType a}, forall (u:(list
  a)) (v:(list a)), (vlist_eq u v) -> (u = v).

  (* -------------------------------------------------------------------- *)
  (* --- neutral elements                                             --- *)
  (* -------------------------------------------------------------------- *)

(* Why3 goal *)
Lemma eq_nil_concat : forall {a:Type} {a_WT:WhyType a}, forall (w:(list a)),
  (vlist_eq (concat (nil : (list a)) w) w) /\ (vlist_eq (concat w
  (nil : (list a))) w).
Proof.
  intros.
  split ; unfold vlist_eq ; rewrite length_concat; rewrite length_nil; split; auto with zarith; intros.
  (* + generalize (nth_concat nil w i); rewrite length_nil; intro G; destruct G.
    rewrite H1.
    * replace (i - 0)%Z with i by (auto with zarith). auto.
    * omega. *)
  + generalize (nth_concat w nil i). intro G; destruct G.
    rewrite H0.
    * auto.
    * omega.
Qed.

(* Why3 goal *)
Lemma rw_nil_concat_left : forall {a:Type} {a_WT:WhyType a}, forall (w:(list
  a)), ((concat (nil : (list a)) w) = w).
Proof.
  intros.
  apply extensionality.
  generalize (eq_nil_concat w). intro G; destruct G.
  apply H.
Qed.

(* Why3 goal *)
Lemma rw_nil_concat_right : forall {a:Type} {a_WT:WhyType a}, forall (w:(list
  a)), ((concat w (nil : (list a))) = w).
 intros.
  apply extensionality.
  generalize (eq_nil_concat w). intro G; destruct G.
  apply H0.
Qed.

(* Why3 goal *)
Lemma eq_cons_concat : forall {a:Type} {a_WT:WhyType a}, forall (x:a)
  (v:(list a)) (w:(list a)), (vlist_eq (concat (cons x v) w) (cons x
  (concat v w))).
Proof.
  intros.
  unfold vlist_eq ; rewrite length_concat. repeat (rewrite length_cons).
  split.
  + rewrite length_concat. ring.
  + intros.
    generalize (nth_cons i x (concat v w)); intro G; destruct G.
    case_eq i 0%Z; intro Position_0.
    * clear H1; rewrite H0; clear H0; auto.
      generalize (nth_concat (cons x v) w i); rewrite length_cons; intro G; destruct G.
      generalize (length_pos v); intro Positive.
      clear H1; rewrite H0 by omega; clear H0.
      generalize (nth_cons i x v); intro G; destruct G.
      clear H1; rewrite H0; clear H0; auto.
    * clear H0; rewrite H1; clear H1; auto.
      generalize (nth_concat (cons x v) w i); rewrite length_cons; intro G; destruct G.
      case_lt i (1+ length v)%Z; intros.
      - clear H1; rewrite H0 by auto; clear H0.
        generalize (nth_cons i x v); intro G; destruct G.
        clear H0; rewrite H1 by auto; clear H1.
        generalize (nth_concat v w (i -1)); intro G; destruct G. 
        clear H1; rewrite H0 by auto with zarith; clear H0.
        auto.
      - clear H0; rewrite H1 by auto; clear H1.
        generalize (nth_concat v w (i -1)); intro G; destruct G. 
        clear H0; rewrite H1 by auto with zarith.
        replace (i - (1 + length v))%Z with (i - 1 - length v)%Z by auto with zarith.
        auto.
Qed.

(* Why3 goal *)
Lemma rw_cons_concat : forall {a:Type} {a_WT:WhyType a}, forall (x:a)
  (v:(list a)) (w:(list a)), ((concat (cons x v) w) = (cons x (concat v w))).
Proof.
  intros.
  apply extensionality.
  apply eq_cons_concat. 
Qed.

(* Why3 goal *)
Lemma rw_nil_cons_concat : forall {a:Type} {a_WT:WhyType a}, forall (x:a)
  (w:(list a)), ((concat (cons x (nil : (list a))) w) = (cons x w)).
Proof.
  intros.
  rewrite rw_cons_concat.
  rewrite rw_nil_concat_left.
  auto.
Qed.

  (* -------------------------------------------------------------------- *)
  (* --- associativity                                                --- *)
  (* -------------------------------------------------------------------- *)

(* Why3 goal *)
Lemma eq_assoc_concat : forall {a:Type} {a_WT:WhyType a}, forall (u:(list a))
  (v:(list a)) (w:(list a)), (vlist_eq (concat (concat u v) w) (concat u
  (concat v w))).
Proof.
  intros.
  unfold vlist_eq. repeat (rewrite length_concat).  split.
  - ring.
  - intros.
    generalize (length_pos u); generalize (length_pos v); intros uPos vPos. 
    case_lt i (length u); intro inU; 
      generalize (nth_concat u (concat v w) i) ; intro G; destruct G.
    + clear H1; rewrite H0 by auto; clear H0.
      generalize (nth_concat (concat u v) w i) ; rewrite length_concat ; intro G; destruct G.
      clear H1; rewrite H0 by omega; clear H0.
      generalize (nth_concat u v i) ; intro G; destruct G.
      clear H1; rewrite H0 by auto; clear H0.
      auto.
   + clear H0; rewrite H1 by auto; clear H1.
     case_lt i ((length u) + (length v)); intro inV; 
       generalize (nth_concat (concat u v) w i) ; rewrite length_concat ; intro G; destruct G.
     * clear H1; rewrite H0 by omega; clear H0.
       generalize (nth_concat u v i) ; intro G; destruct G.
       clear H0; rewrite H1 by auto; clear H1.
       generalize (nth_concat v w (i - length u)) ; intro G; destruct G.
       clear H1; rewrite H0 by omega; clear H0.
       auto.
     * clear H0; rewrite H1 by omega; clear H1.
       generalize (nth_concat v w (i - length u)) ; intro G; destruct G.
       clear H0; rewrite H1 by omega; clear H1.
       replace (i - (length u + length v)) with (i - length u - length v) by auto with zarith.
       auto.
Qed.

(* Why3 goal *)
Lemma rw_nil_repeat : forall {a:Type} {a_WT:WhyType a}, forall (n:Z),
  (0%Z <= n)%Z -> ((repeat (nil : (list a)) n) = (nil : (list a))).
Proof.
  intros a a_WT n h1.
  apply length_nil_bis.
  rewrite length_repeat.
  + rewrite length_nil.
    auto with zarith.
  + omega.
Qed.

  (* -------------------------------------------------------------------- *)
  (* --- repeat                                                       --- *)
  (* -------------------------------------------------------------------- *)

(* Why3 goal *)
Lemma rw_repeat_zero : forall {a:Type} {a_WT:WhyType a}, forall (w:(list a)),
  ((repeat w 0%Z) = (nil : (list a))).
Proof.
  intros.
  apply length_nil_bis.
  rewrite length_repeat.
  + auto with zarith.
  + omega.
Qed.

(* Why3 goal *)
Hypothesis eq_repeat_one : forall {a:Type} {a_WT:WhyType a}, forall (w:(list
  a)), (vlist_eq (repeat w 1%Z) w).

(* Why3 goal *)
Lemma rw_repeat_one : forall {a:Type} {a_WT:WhyType a}, forall (w:(list a)),
  ((repeat w 1%Z) = w).
Proof.
  intros.
  apply extensionality.
  apply eq_repeat_one; auto.
Qed.

(* Why3 goal *)
Lemma eq_repeat_concat : forall {a:Type} {a_WT:WhyType a}, forall (p:Z) (q:Z)
  (w:(list a)), (0%Z <= p)%Z -> ((0%Z <= q)%Z -> (vlist_eq (repeat w
  (p + q)%Z) (concat (repeat w p) (repeat w q)))).
Proof.
  intros a a_WT p q w h1 h2.
  unfold vlist_eq. split.
  - rewrite length_concat.
    repeat (rewrite length_repeat) ; auto with zarith.
  - intros i Rg.
    induction (Z_lt_ge_dec 0 (length w)).
    {
    rewrite length_repeat in Rg ; auto with zarith.
    rewrite nth_repeat ; auto with zarith.
    elim (nth_concat (repeat w p) (repeat w q) i).
    repeat rewrite length_repeat ; auto with zarith.
    intros Left Right.
    induction (Z_lt_dec i (p * length w)) as [left|right].
    + rewrite Left ; auto.
      rewrite nth_repeat ; auto with zarith.
    + rewrite Right ; auto.
      replace ((p+q) * length w)%Z with (p*length w + q*length w)%Z
      in Rg by ring.
      rewrite nth_repeat ; auto with zarith.
      pose (j := (i - p * length w)%Z). fold j.
      replace i with (p * length w + j)%Z by (unfold j ; auto with zarith).
      replace (p * length w)%Z with (length w * p)%Z by ring.
      rewrite ComputerDivision.Mod_mult. auto.
      unfold j.
      intuition auto with zarith.
    }
    {
    generalize (length_pos w). intro Pos.
    assert (Zero: length w = 0%Z) by auto with zarith.
    rewrite length_repeat in Rg ; auto with zarith.
    rewrite Zero in Rg ; apply False_ind. omega.
    }
Qed.

(* Why3 goal *)
Lemma rw_repeat_concat : forall {a:Type} {a_WT:WhyType a}, forall (p:Z) (q:Z)
  (w:(list a)), (0%Z <= p)%Z -> ((0%Z <= q)%Z -> ((repeat w
  (p + q)%Z) = (concat (repeat w p) (repeat w q)))).
Proof.
  intros.
  apply extensionality.
  apply eq_repeat_concat; auto.
Qed.

(* Why3 goal *)
Lemma rw_repeat_after : forall {a:Type} {a_WT:WhyType a}, forall (p:Z)
  (w:(list a)), (0%Z <= p)%Z -> ((concat (repeat w p) w) = (repeat w
  (p + 1%Z)%Z)).
Proof.
  intros.
  rewrite (rw_repeat_concat p 1) by omega.
  rewrite rw_repeat_one. auto.
Qed.

(* Why3 goal *)
Lemma rw_repeat_before : forall {a:Type} {a_WT:WhyType a}, forall (p:Z)
  (w:(list a)), (0%Z <= p)%Z -> ((concat w (repeat w p)) = (repeat w
  (p + 1%Z)%Z)).
Proof.
  intros.
  replace (p + 1)%Z with (1 + p)%Z by ring.
  rewrite (rw_repeat_concat 1 p) by omega.
  rewrite rw_repeat_one.
  auto.
Qed.

(* Why3 goal *)
Definition repeat_box: forall {a:Type} {a_WT:WhyType a}, (list a) -> Z ->
  (list a).
  exact(@repeat).
Defined.

(* Why3 goal *)
Lemma rw_repeat_box_unfold : forall {a:Type} {a_WT:WhyType a},
  forall (w:(list a)) (n:Z), ((repeat_box w n) = (repeat w n)).
Proof.
  intros a a_WT w n.
  unfold repeat_box. auto.
Qed.

(* Why3 goal *)
Lemma rw_repeat_plus_box_unfold : forall {a:Type} {a_WT:WhyType a},
  forall (w:(list a)) (a1:Z) (b:Z), (0%Z <= a1)%Z -> ((0%Z <= b)%Z ->
  ((repeat_box w (a1 + b)%Z) = (concat (repeat w a1) (repeat w b)))).
Proof. 
  intros a a_WT w a1 b h1 h2.
  rewrite rw_repeat_box_unfold.
  apply rw_repeat_concat; auto.
Qed.

(* Why3 goal *)
Lemma rw_repeat_plus_one_box_unfold : forall {a:Type} {a_WT:WhyType a},
  forall (w:(list a)) (n:Z), (0%Z < n)%Z -> (((repeat_box w
  n) = (concat (repeat w (n - 1%Z)%Z) w)) /\ ((repeat_box w
  (n + 1%Z)%Z) = (concat (repeat w n) w))).
Proof.
  intros a a_WT w n h1.
  split.
  + replace n with ((n - 1)+1)%Z by ring.
    rewrite rw_repeat_plus_box_unfold.
    - replace (n - 1 + 1 -1)%Z with (n - 1)%Z by ring.
      rewrite rw_repeat_one.
      auto.
    - omega.
    - omega.
  + rewrite rw_repeat_plus_box_unfold.
    rewrite rw_repeat_one.
    - auto.
    - omega.
    - omega.
Qed.

