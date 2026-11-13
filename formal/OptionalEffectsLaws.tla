-------------------------- MODULE OptionalEffectsLaws --------------------------
(* Finite model of Sources/OptionalAPI, part 2: the parts that count effects    *)
(* or work on collections: recoverFromEmpty / hasElements / isNoneOrEmpty,      *)
(* sequence / traverse (short-circuit), whenSome / whenNone / tryWhenSome,      *)
(* throwOrGetValue, andThenTry / andThenTryOrThrow (+ async twins).             *)
(* Closures that run user code are modelled by a call counter. A Collection is  *)
(* a sequence over Vals of length 0..2. A throwing transform returns the token  *)
(* Err instead of a value.                                                      *)
EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS Vals, Mutant

None    == [tag |-> "none", v |-> 0]
Some(x) == [tag |-> "some", v |-> x]
Opts    == {None} \cup {Some(x) : x \in Vals}
IsSome(o) == o.tag = "some"
IsNone(o) == o.tag = "none"

Colls    == UNION {[1..n -> Vals] : n \in 0..2}
OptColls == {None} \cup {Some(c) : c \in Colls}
OptLists == UNION {[1..n -> Opts] : n \in 0..3}
ValLists == UNION {[1..n -> Vals] : n \in 0..2}
KFns     == [Vals -> Opts]
Fns      == [Vals -> Vals]
Preds    == [Vals -> BOOLEAN]
Err      == [tag |-> "err", v |-> 0]
TVals    == Vals \cup {Err}            \* result of a throwing transform
TFns     == [Vals -> {Some(x) : x \in Vals} \cup {Err}]

\* OptionalCollection.swift
HasElements(oc)   == IF IsSome(oc) THEN oc.v # <<>> ELSE FALSE
IsNoneOrEmpty(oc) == IF IsSome(oc) THEN oc.v = <<>> ELSE TRUE
Recover(oc, d) ==
  IF IsSome(oc)
  THEN (IF oc.v = <<>> \/ Mutant = "recover_replaces_nonempty"
        THEN [r |-> Some(d), calls |-> 1] ELSE [r |-> oc, calls |-> 0])
  ELSE [r |-> None, calls |-> IF Mutant = "recover_always_calls" THEN 1 ELSE 0]
AsyncRecover(oc, d) ==
  IF IsSome(oc)
  THEN (IF oc.v = <<>> THEN [r |-> Some(d), calls |-> 1] ELSE [r |-> oc, calls |-> 0])
  ELSE [r |-> None, calls |-> 0]

\* Traversable.swift
Sequence(l) ==
  IF \A i \in DOMAIN l : IsSome(l[i])
  THEN Some([i \in DOMAIN l |-> l[i].v])
  ELSE IF Mutant = "sequence_skips_none"
       THEN LET idx == {i \in DOMAIN l : IsSome(l[i])}
            IN Some([j \in 1..Cardinality(idx) |->
                       l[CHOOSE i \in idx : Cardinality({k \in idx : k < i}) = j - 1].v])
       ELSE None
FirstNone(xs, f) ==
  CHOOSE i \in DOMAIN xs : IsNone(f[xs[i]]) /\ \A j \in 1..(i - 1) : IsSome(f[xs[j]])
Traverse(xs, f) ==
  [r |-> Sequence([i \in DOMAIN xs |-> f[xs[i]]]),
   calls |-> IF \E i \in DOMAIN xs : IsNone(f[xs[i]])
             THEN (IF Mutant = "traverse_no_short_circuit" THEN Len(xs) ELSE FirstNone(xs, f))
             ELSE Len(xs)]

\* RunWhen.swift: result paired with how many times the block ran
WhenSome(o)  == [r |-> o, runs |-> IF IsSome(o) \/ Mutant = "when_some_runs_on_none" THEN 1 ELSE 0]
WhenNone(o)  == [r |-> o, runs |-> IF IsNone(o) THEN 1 ELSE 0]
\* tryWhenSome: block throws for values in `th`; Err result models the rethrow
TryWhenSome(o, th) ==
  IF IsSome(o) /\ th[o.v] THEN Err ELSE o

\* OptionalError.swift
ThrowOrGet(o) ==
  IF IsSome(o)
  THEN [r |-> o.v, threw |-> FALSE,
        calls |-> IF Mutant = "throw_error_built_eagerly" THEN 1 ELSE 0]
  ELSE [r |-> 0, threw |-> TRUE, calls |-> 1]

\* AndThen.swift: transform t either yields Some(x)/None-like result or throws (Err)
AndThenTry(o, t) ==
  IF IsSome(o) /\ t[o.v] # Err THEN t[o.v]
  ELSE IF Mutant = "try_error_becomes_some" /\ IsSome(o) THEN Some(0) ELSE None
AndThenTryOrThrow(o, t) ==
  IF IsSome(o) THEN t[o.v] ELSE None            \* may return Err (== rethrow)
TryAsyncAndThenTry(o, t) ==
  IF IsSome(o) THEN (IF t[o.v] = Err THEN None ELSE t[o.v]) ELSE None
TryAsyncAndThenTryOrThrow(o, t) == IF IsSome(o) THEN t[o.v] ELSE None

VARIABLES o, oc, l, xs
vars == <<o, oc, l, xs>>
Init == o \in Opts /\ oc \in OptColls /\ l \in OptLists /\ xs \in ValLists
Next == UNCHANGED vars
Spec == Init /\ [][Next]_vars

TypeOK == o \in Opts /\ oc \in OptColls /\ l \in OptLists /\ xs \in ValLists

\* ---- collections
HasElementsIsNotNoneOrEmpty == HasElements(oc) = ~IsNoneOrEmpty(oc)
NoneIsNoneOrEmpty == IsNoneOrEmpty(None) /\ ~HasElements(None)
RecoverNoneStaysNone == \A d \in Colls : Recover(None, d) = [r |-> None, calls |-> 0]
RecoverKeepsNonEmpty ==
  \A d \in Colls : (IsSome(oc) /\ oc.v # <<>>) => Recover(oc, d).r = oc
RecoverFillsEmpty ==
  \A d \in Colls : (IsSome(oc) /\ oc.v = <<>>) => Recover(oc, d).r = Some(d)
RecoverIsLazy ==
  \A d \in Colls :
    Recover(oc, d).calls = (IF IsSome(oc) /\ oc.v = <<>> THEN 1 ELSE 0)
RecoverWithNonEmptyDefaultHasElements ==
  \A d \in Colls : (IsSome(oc) /\ d # <<>>) => HasElements(Recover(oc, d).r)
AsyncRecoverAgrees == \A d \in Colls : AsyncRecover(oc, d) = Recover(oc, d)

\* ---- sequence / traverse
SequenceAllOrNothing ==
  IsSome(Sequence(l)) = (\A i \in DOMAIN l : IsSome(l[i]))
SequencePreservesOrderAndLength ==
  IsSome(Sequence(l)) =>
    Len(Sequence(l).v) = Len(l) /\ \A i \in DOMAIN l : Sequence(l).v[i] = l[i].v
SequenceEmptyIsSomeEmpty == Sequence(<<>>) = Some(<<>>)
SequenceNoneIfAnyNone ==
  (\E i \in DOMAIN l : IsNone(l[i])) => Sequence(l) = None
TraverseIsSequenceOfMap ==
  \A f \in KFns : Traverse(xs, f).r = Sequence([i \in DOMAIN xs |-> f[xs[i]]])
TraverseShortCircuits ==
  \A f \in KFns :
    (\E i \in DOMAIN xs : IsNone(f[xs[i]]))
      => Traverse(xs, f).calls = FirstNone(xs, f)
TraverseCallsAllWhenTotal ==
  \A f \in KFns :
    (\A i \in DOMAIN xs : IsSome(f[xs[i]])) => Traverse(xs, f).calls = Len(xs)
TraverseWithSomeIsMap ==
  \A g \in Fns :
    Traverse(xs, [x \in Vals |-> Some(g[x])]).r = Some([i \in DOMAIN xs |-> g[xs[i]]])

\* ---- whenSome / whenNone
WhenReturnsSelf == WhenSome(o).r = o /\ WhenNone(o).r = o
WhenSomeRunsIffSome == WhenSome(o).runs = (IF IsSome(o) THEN 1 ELSE 0)
WhenNoneRunsIffNone == WhenNone(o).runs = (IF IsNone(o) THEN 1 ELSE 0)
WhenSomeXorWhenNone == WhenSome(o).runs + WhenNone(o).runs = 1
TryWhenSomeThrowsOnlyForSomeThatThrows ==
  \A th \in Preds :
    (TryWhenSome(o, th) = Err) = (IsSome(o) /\ th[o.v])
    /\ (TryWhenSome(o, th) # Err => TryWhenSome(o, th) = o)

\* ---- throwOrGetValue
ThrowOrGetValueOnSome == IsSome(o) => ThrowOrGet(o).r = o.v /\ ~ThrowOrGet(o).threw
ThrowOrGetValueThrowsOnNone == IsNone(o) => ThrowOrGet(o).threw
ErrorBuiltLazily == ThrowOrGet(o).calls = (IF IsNone(o) THEN 1 ELSE 0)

\* ---- andThenTry family
TryNeverErrs == \A t \in TFns : AndThenTry(o, t) # Err
TryEqualsOrThrowWhenNoThrow ==
  \A t \in TFns : (AndThenTryOrThrow(o, t) # Err) => AndThenTry(o, t) = AndThenTryOrThrow(o, t)
TryIsNoneWhenOrThrowThrows ==
  \A t \in TFns : (AndThenTryOrThrow(o, t) = Err) => AndThenTry(o, t) = None
TryOnNoneIsNone == \A t \in TFns : AndThenTry(None, t) = None /\ AndThenTryOrThrow(None, t) = None
AsyncTryAgrees ==
  \A t \in TFns :
    TryAsyncAndThenTry(o, t) = AndThenTry(o, t)
    /\ TryAsyncAndThenTryOrThrow(o, t) = AndThenTryOrThrow(o, t)
=============================================================================
