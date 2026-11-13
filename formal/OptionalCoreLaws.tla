--------------------------- MODULE OptionalCoreLaws ---------------------------
(* Finite model of Sources/OptionalAPI, part 1: the operator families map /    *)
(* flatMap(andThen) / ap / filter / flatten / fold / or / mapNone / defaultSome *)
(* / orOptional / coalesce / someWhen / noneWhen / isSome-family / cast /       *)
(* encode+decode, plus the async twins which are hand-written switches.         *)
(* Optional<T> is [tag, v]. Transforms range over the FULL finite function      *)
(* space, so each law holds for every closure. "Producer" closures are modelled *)
(* by a call counter so laziness (autoclosure) is checkable.                    *)
(* Abstractions: T is Vals = {0,1}; Foundation JSON and Swift `as?` bridging are *)
(* abstracted (see README Limits). Throwing/collection/traversal: see           *)
(* OptionalEffectsLaws.                                                         *)
EXTENDS Naturals, Sequences

CONSTANTS Vals, Mutant

None    == [tag |-> "none", v |-> 0]
Some(x) == [tag |-> "some", v |-> x]
Opts    == {None} \cup {Some(x) : x \in Vals}
NestedOpts == {None} \cup {Some(o) : o \in Opts}
Fns     == [Vals -> Vals]
KFns    == [Vals -> Opts]
Preds   == [Vals -> BOOLEAN]
FOpts   == {None} \cup {Some(f) : f \in Fns}
Seqs    == UNION {[1..n -> Opts] : n \in 0..3}
Id      == [x \in Vals |-> x]

\* OptionalProperties.swift
IsSome(o)    == o.tag = "some"
IsNone(o)    == o.tag = "none"
IsNotNone(o) == o.tag = "some"
IsNotSome(o) == o.tag = "none"

\* Optional.map / flatMap (stdlib) used throughout the library.
Map(o, f)     == IF IsSome(o) THEN Some(f[o.v]) ELSE None
FlatMap(o, k) == IF IsSome(o) THEN k[o.v] ELSE None

\* AndThen.swift
AndThen(o, k) == FlatMap(o, k)
AsyncAndThen(o, k) == IF IsSome(o) THEN k[o.v] ELSE None
AsyncMap(o, f)     == IF IsSome(o) THEN Some(f[o.v]) ELSE None
AsyncFlatMap(o, k) == IF IsSome(o) THEN k[o.v] ELSE None

\* Applicative.swift (function payloads: fo = Some(f) | None)
Ap(fo, o) ==
  IF IsSome(fo)
  THEN (IF Mutant = "ap_ignores_none_value" THEN Some(fo.v[o.v])
        ELSE IF IsSome(o) THEN Some(fo.v[o.v]) ELSE None)
  ELSE None
AsyncAp(fo, o) ==
  IF IsSome(fo) THEN (IF IsSome(o) THEN Some(fo.v[o.v]) ELSE None) ELSE None

\* Filter.swift  (switch map(predicate) { case true?: self; default: .none })
Filter(o, p) ==
  IF Mutant = "filter_keeps_all" THEN o
  ELSE IF Map(o, p) = Some(TRUE) THEN o ELSE None
AsyncFilter(o, p) == IF IsSome(o) THEN (IF p[o.v] THEN o ELSE None) ELSE None

\* ConditionalConstruction.swift
SomeWhen(p, x) == IF p[x] THEN Some(x) ELSE None
NoneWhen(p, x) ==
  IF Mutant = "nonewhen_same_as_somewhen" THEN SomeWhen(p, x)
  ELSE IF p[x] THEN None ELSE Some(x)

\* Flatten.swift
Flatten(n) ==
  IF IsSome(n)
  THEN (IF Mutant = "flatten_inner_none_becomes_some" /\ IsNone(n.v)
        THEN Some(0) ELSE n.v)
  ELSE None

\* Folds.swift  (map(someCase) ?? noneCase)
Fold(o, d, f) == IF IsSome(Map(o, f)) THEN Map(o, f).v ELSE d
AsyncFold(o, d, f) ==
  IF IsSome(o) THEN f[o.v]
  ELSE IF Mutant = "async_fold_wrong_none_case" THEN f[0] ELSE d

\* Or.swift / Maps.swift. Result paired with the number of producer calls.
Or(o, d) ==
  IF IsSome(o)
  THEN [r |-> o.v, calls |-> IF Mutant = "or_eager" THEN 1 ELSE 0]
  ELSE [r |-> d, calls |-> 1]
AsyncOr(o, d) == IF IsSome(o) THEN [r |-> o.v, calls |-> 0] ELSE [r |-> d, calls |-> 1]
MapNone(o, d)       == Some(Or(o, d).r)     \* also the free mapNone (calls optional.or)
DefaultSome(o, d)   == Some(Or(o, d).r)     \* also the free defaultSome
AsyncMapNone(o, d)  == IF IsSome(o) THEN o ELSE Some(d)
AsyncDefaultSome(o, d) == IF IsSome(o) THEN o ELSE Some(d)

\* Alternative.swift
OrOptional(o, q) == IF IsSome(o) THEN o ELSE q
RECURSIVE FoldAlt(_)
FoldAlt(s) == IF s = <<>> THEN None ELSE OrOptional(Head(s), FoldAlt(Tail(s)))
Coalesce(s) ==
  IF \E i \in DOMAIN s : IsSome(s[i])
  THEN s[CHOOSE i \in DOMAIN s :
           IsSome(s[i]) /\
           (IF Mutant = "coalesce_last_wins"
            THEN \A j \in (i + 1)..Len(s) : IsNone(s[j])
            ELSE \A j \in 1..(i - 1) : IsNone(s[j]))]
  ELSE None

\* Cast.swift: Any = [ty, v] with two dynamic types
Types == {"A", "B"}
Anys  == [ty : Types, v : Vals]
OptAnys == {None} \cup {Some(a) : a \in Anys}
CastTo(a, T) == IF a.ty = T \/ Mutant = "cast_ignores_type" THEN Some(a.v) ELSE None
OptCast(oa, T) == IF IsSome(oa) THEN CastTo(oa.v, T) ELSE None

\* OptionalCodable.swift: Data abstracted to Vals plus an undecodable token
Junk  == [k |-> "junk", x |-> 0]
Datas == {[k |-> "ok", x |-> x] : x \in Vals} \cup {Junk}
OptDatas == {None} \cup {Some(d) : d \in Datas}
Encode(o) == IF IsSome(o) THEN Some([k |-> "ok", x |-> o.v]) ELSE None   \* JSONEncoder abstracted
Decode(od) ==
  IF IsSome(od)
  THEN (IF od.v.k = "junk" THEN (IF Mutant = "decode_junk_becomes_some" THEN Some(0) ELSE None)
        ELSE Some(od.v.x))
  ELSE None

VARIABLES o, p, s, oa, od
vars == <<o, p, s, oa, od>>
Init == o \in Opts /\ p \in Opts /\ s \in Seqs /\ oa \in OptAnys /\ od \in OptDatas
Next == UNCHANGED vars
Spec == Init /\ [][Next]_vars

TypeOK == o \in Opts /\ p \in Opts /\ s \in Seqs /\ oa \in OptAnys /\ od \in OptDatas

\* ---- properties
PropertiesAreComplements ==
  IsSome(o) # IsNone(o) /\ IsNotNone(o) = IsSome(o) /\ IsNotSome(o) = IsNone(o)

\* ---- functor / monad (andThen)
MapIdentity == Map(o, Id) = o
MapComposition ==
  \A f, g \in Fns : Map(Map(o, f), g) = Map(o, [x \in Vals |-> g[f[x]]])
MonadLeftIdentity ==
  \A k \in KFns : \A x \in Vals : AndThen(Some(x), k) = k[x]
MonadRightIdentity == AndThen(o, [x \in Vals |-> Some(x)]) = o
MonadAssociativity ==
  \A k1, k2 \in KFns :
    AndThen(AndThen(o, k1), k2) = AndThen(o, [x \in Vals |-> AndThen(k1[x], k2)])
AndThenNoneAbsorbs == \A k \in KFns : AndThen(None, k) = None
AsyncAgreesWithSync ==
  \A f \in Fns, k \in KFns, pr \in Preds, d \in Vals :
    AsyncMap(o, f) = Map(o, f) /\ AsyncFlatMap(o, k) = FlatMap(o, k)
    /\ AsyncAndThen(o, k) = AndThen(o, k) /\ AsyncFilter(o, pr) = Filter(o, pr)
    /\ AsyncFold(o, d, f) = Fold(o, d, f) /\ AsyncOr(o, d) = Or(o, d)
    /\ AsyncMapNone(o, d) = MapNone(o, d)
    /\ AsyncDefaultSome(o, d) = DefaultSome(o, d)
    /\ AsyncAp(Some(f), o) = Ap(Some(f), o) /\ AsyncAp(None, o) = Ap(None, o)
    /\ AsyncAp(Some(f), None) = Ap(Some(f), None)

\* ---- applicative
ApSomeSome == \A f \in Fns, x \in Vals : Ap(Some(f), Some(x)) = Some(f[x])
ApNoneValue == \A f \in Fns : Ap(Some(f), None) = None
ApNoneFunction == Ap(None, o) = None
ApIsMap == \A f \in Fns : Ap(Some(f), o) = Map(o, f)
ApIdentity == Ap(Some(Id), o) = o

\* ---- filter / someWhen / noneWhen
FilterIsSubset == \A pr \in Preds : Filter(o, pr) = o \/ Filter(o, pr) = None
FilterKeepsIffPredicate ==
  \A pr \in Preds, x \in Vals : Filter(Some(x), pr) = (IF pr[x] THEN Some(x) ELSE None)
FilterNoneIsNone == \A pr \in Preds : Filter(None, pr) = None
FilterIdempotent == \A pr \in Preds : Filter(Filter(o, pr), pr) = Filter(o, pr)
FilterFusion ==
  \A pr, q \in Preds :
    Filter(Filter(o, pr), q) = Filter(o, [x \in Vals |-> pr[x] /\ q[x]])
FilterViaFlatMap ==
  \A pr \in Preds : Filter(o, pr) = FlatMap(o, [x \in Vals |-> SomeWhen(pr, x)])
SomeWhenIsFilterOfSome == \A pr \in Preds, x \in Vals : SomeWhen(pr, x) = Filter(Some(x), pr)
NoneWhenComplementsSomeWhen ==
  \A pr \in Preds, x \in Vals :
    NoneWhen(pr, x) = SomeWhen([y \in Vals |-> ~pr[y]], x)
    /\ (IsSome(NoneWhen(pr, x)) # IsSome(SomeWhen(pr, x)))

\* ---- flatten
FlattenCases ==
  Flatten(None) = None
  /\ Flatten(Some(None)) = None
  /\ \A x \in Vals : Flatten(Some(Some(x))) = Some(x)
FlattenIsFlatMapId ==
  \A n \in NestedOpts : Flatten(n) = FlatMap(n, [x \in Opts |-> x])
FlattenIsJoin ==
  \A k \in KFns : FlatMap(o, k) = Flatten(Map(o, k))
FlattenUnit == Flatten(Map(o, [x \in Vals |-> Some(x)])) = o
FlattenOfNestedNone == \A n \in NestedOpts : IsNone(n) => Flatten(n) = None

\* ---- fold
FoldCases ==
  \A d \in Vals, f \in Fns :
    Fold(None, d, f) = d /\ \A x \in Vals : Fold(Some(x), d, f) = f[x]
FoldWithIdIsOr == \A d \in Vals : Fold(o, d, Id) = Or(o, d).r

\* ---- or / mapNone / defaultSome / orOptional / coalesce
OrValue == \A d \in Vals : Or(o, d).r = (IF IsSome(o) THEN o.v ELSE d)
OrIsLazy == \A d \in Vals : IsSome(o) => Or(o, d).calls = 0
OrProducerRunsOnceWhenNone == \A d \in Vals : IsNone(o) => Or(o, d).calls = 1
MapNoneAlwaysSome ==
  \A d \in Vals : IsSome(MapNone(o, d)) /\ MapNone(MapNone(o, d), d) = MapNone(o, d)
MapNoneEqualsDefaultSome == \A d \in Vals : MapNone(o, d) = DefaultSome(o, d)
OrOptionalOfSomeIsMapNone == \A d \in Vals : OrOptional(o, Some(d)) = MapNone(o, d)
OrOptionalLaws ==
  OrOptional(None, p) = p /\ OrOptional(o, None) = o
  /\ \A q \in Opts : OrOptional(OrOptional(o, p), q) = OrOptional(o, OrOptional(p, q))
  /\ IsSome(o) => OrOptional(o, p) = o
CoalesceMatchesFold == Coalesce(s) = FoldAlt(s)
CoalesceEmptyIsNone == Coalesce(<<>>) = None
CoalesceIsFirstSome ==
  \A i \in DOMAIN s : IsSome(s[i]) /\ (\A j \in 1..(i - 1) : IsNone(s[j])) => Coalesce(s) = s[i]
CoalesceAllNone == (\A i \in DOMAIN s : IsNone(s[i])) => Coalesce(s) = None
CoalesceAgreesWithOrOptional == Coalesce(<<o, p>>) = OrOptional(o, p)

\* ---- cast / codable round trips
CastSameTypeKeeps ==
  \A a \in Anys : OptCast(Some(a), a.ty) = Some(a.v)
CastOtherTypeIsNone ==
  \A a \in Anys, T \in Types : T # a.ty => OptCast(Some(a), T) = None
CastNoneIsNone == \A T \in Types : OptCast(None, T) = None
CastResultIsSomeOnlyIfSome == \A T \in Types : IsSome(OptCast(oa, T)) => IsSome(oa)
EncodeDecodeRoundTrip == Decode(Encode(o)) = o
DecodeFailureIsNone == Decode(Some(Junk)) = None /\ Decode(None) = None
=============================================================================
