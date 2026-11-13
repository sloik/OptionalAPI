# Formal model (TLA+)

Two finite TLA+ modules model the public semantics of `Sources/OptionalAPI`. `Optional<T>` is
`[tag, v]` over `Vals = {0, 1}`; transforms (`Fns`, `KFns`, `Preds`) range over their **full** finite
function spaces, so each law holds for every closure. "Producer" and "block" closures are modelled by a
call counter, which makes autoclosure laziness and short-circuiting checkable.

## `OptionalCoreLaws.tla`

| Invariant(s) | Swift API it abstracts |
|---|---|
| `PropertiesAreComplements` | `isNone` / `isSome` / `isNotNone` / `isNotSome` (+ free functions) |
| `MapIdentity`, `MapComposition` | `Optional.map` as used by the library |
| `MonadLeftIdentity`, `MonadRightIdentity`, `MonadAssociativity`, `AndThenNoneAbsorbs` | `andThen` (== `flatMap`), free `andThen` |
| `AsyncAgreesWithSync` | `asyncMap`, `asyncFlatMap`, `asyncAndThen`, `asyncFilter`, `asyncFold`, `asyncOr`, `asyncMapNone`, `asyncDefaultSome`, `asyncAp` equal their sync twins (the async ones are separate hand-written switches) |
| `ApSomeSome`, `ApNoneValue`, `ApNoneFunction`, `ApIsMap`, `ApIdentity` | `ap`, `asyncAp`, free `ap` |
| `FilterIsSubset`, `FilterKeepsIffPredicate`, `FilterNoneIsNone`, `FilterIdempotent`, `FilterFusion`, `FilterViaFlatMap` | `filter` |
| `SomeWhenIsFilterOfSome`, `NoneWhenComplementsSomeWhen` | `someWhen`, `noneWhen` |
| `FlattenCases`, `FlattenIsFlatMapId`, `FlattenIsJoin`, `FlattenUnit`, `FlattenOfNestedNone` | `flatten` |
| `FoldCases`, `FoldWithIdIsOr` | `fold`, `asyncFold` |
| `OrValue`, `OrIsLazy`, `OrProducerRunsOnceWhenNone` | `or` (producer evaluated only for `.none`) |
| `MapNoneAlwaysSome`, `MapNoneEqualsDefaultSome`, `OrOptionalOfSomeIsMapNone` | `mapNone`, `defaultSome` (+ free functions) |
| `OrOptionalLaws` | `orOptional` (identity, associativity, left bias) |
| `CoalesceMatchesFold`, `CoalesceEmptyIsNone`, `CoalesceIsFirstSome`, `CoalesceAllNone`, `CoalesceAgreesWithOrOptional` | `coalesce` (variadic and array) |
| `CastSameTypeKeeps`, `CastOtherTypeIsNone`, `CastNoneIsNone`, `CastResultIsSomeOnlyIfSome` | `cast` |
| `EncodeDecodeRoundTrip`, `DecodeFailureIsNone` | `encode` / `decode` (+ async) |

## `OptionalEffectsLaws.tla`

| Invariant(s) | Swift API it abstracts |
|---|---|
| `HasElementsIsNotNoneOrEmpty`, `NoneIsNoneOrEmpty` | `hasElements`, `isNoneOrEmpty` |
| `RecoverNoneStaysNone`, `RecoverKeepsNonEmpty`, `RecoverFillsEmpty`, `RecoverIsLazy`, `RecoverWithNonEmptyDefaultHasElements`, `AsyncRecoverAgrees` | `recoverFromEmpty`, `asyncRecoverFromEmpty` |
| `SequenceAllOrNothing`, `SequencePreservesOrderAndLength`, `SequenceEmptyIsSomeEmpty`, `SequenceNoneIfAnyNone` | `sequence` |
| `TraverseIsSequenceOfMap`, `TraverseShortCircuits`, `TraverseCallsAllWhenTotal`, `TraverseWithSomeIsMap` | `traverse` (stops at the first `nil`) |
| `WhenReturnsSelf`, `WhenSomeRunsIffSome`, `WhenNoneRunsIffNone`, `WhenSomeXorWhenNone`, `TryWhenSomeThrowsOnlyForSomeThatThrows` | `whenSome`, `whenNone`, `tryWhenSome` (+ async) |
| `ThrowOrGetValueOnSome`, `ThrowOrGetValueThrowsOnNone`, `ErrorBuiltLazily` | `throwOrGetValue` |
| `TryNeverErrs`, `TryEqualsOrThrowWhenNoThrow`, `TryIsNoneWhenOrThrowThrows`, `TryOnNoneIsNone`, `AsyncTryAgrees` | `andThenTry`, `andThenTryOrThrow`, `tryAsyncAndThenTry`, `tryAsyncAndThenTryOrThrow` |

## Abstractions

- `T` is `{0, 1}`; collections are sequences over it of length 0..2; `[T?]` lists have length 0..3.
- `Data` / `JSONEncoder` / `JSONDecoder`: `encode` is an injective tagging, an undecodable payload
  is one token `junk`. Real JSON edge cases (fragments, number formatting, Linux Foundation
  differences) are not modelled.
- `cast`: dynamic type is a tag in `{A, B}`; Swift `as?` bridging (`Int`/`Double`/`NSNumber`,
  class hierarchies, existential boxing) is not modelled.
- A throwing transform returns an `Err` token; `try?` maps it to `.none`, `try` propagates it.
- `Optional.or(@autoclosure)` forwards to the closure overload `or(_: Producer)`; the model assumes
  that overload resolution (no infinite recursion), as the XCTest suite exercises it.
- Async twins are modelled as separate definitions mirroring the Swift `switch`es and compared to
  their sync versions; scheduling, cancellation and `@Sendable` are out of scope.

## Non-vacuity

Every `<Module>.<mutant>.cfg` seeds one bug via `Mutant` and names the catching invariant. Core: `filter_keeps_all`
(`FilterKeepsIffPredicate`), `or_eager` (`OrIsLazy`), `coalesce_last_wins` (`CoalesceIsFirstSome`),
`flatten_inner_none_becomes_some` (`FlattenCases`), `ap_ignores_none_value` (`ApNoneValue`),
`nonewhen_same_as_somewhen` (`NoneWhenComplementsSomeWhen`), `async_fold_wrong_none_case`
(`AsyncAgreesWithSync`), `decode_junk_becomes_some` (`DecodeFailureIsNone`), `cast_ignores_type`
(`CastOtherTypeIsNone`). Effects: `sequence_skips_none` (`SequenceAllOrNothing`), `traverse_no_short_circuit`
(`TraverseShortCircuits`), `recover_always_calls` (`RecoverIsLazy`), `recover_replaces_nonempty`
(`RecoverKeepsNonEmpty`), `when_some_runs_on_none` (`WhenSomeRunsIffSome`), `throw_error_built_eagerly`
(`ErrorBuiltLazily`), `try_error_becomes_some` (`TryIsNoneWhenOrThrowThrows`). `run_tlc.sh` fails if a mutant passes.

## Running

```sh
TLA_JAR=/path/to/tla2tools-1.7.4.jar formal/run_tlc.sh   # needs Java 11+
```

The script checks the jar's SHA-256 against the pinned tla2tools 1.7.4. CI runs it on a self-hosted
Oracle ARM64 runner, only on pushes to `master` or by manual dispatch (`.github/workflows/oracle-tla.yml`).

## Findings

None: every modelled law holds for the code as read.

## Limits

The model describes the semantics read by hand from the Swift sources; it does not prove the Swift
code conforms (XCTest does that). If the Swift behaviour changes, update the model in the same PR.
Not modelled: `Optional.isNotNone`/`isNotSome` being literal duplicates of `isSome`/`isNone` is
captured only as equalities; generics beyond one small carrier; `Producer`/`AliasWonderland` types.
