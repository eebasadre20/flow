# Changelog

## 0.10.3

*Release Date*: 2019/9/27

- Delegate `operation_failure` to `flow.failed_operation` ([#125](https://github.com/Freshly/flow/pull/125))

## 0.10.2

*Release Date*: 2019/9/18

- Losen gemspec requirements to allow the Rails 6 suite ([#123](https://github.com/Freshly/flow/pull/123))
- Documentation updates
- Tweak operation spec generator

## 0.10.1

*Release Date*: 2019/6/14

- less pessimistic gemspec requirements [#109](https://github.com/Freshly/flow/pull/109)
- `with_failing_operation` shared context [#110](https://github.com/Freshly/flow/pull/110)
- allow triggering a flow with a provided state [#112](https://github.com/Freshly/flow/pull/112)

## 0.10.0

*Release Date*: 2019/5/12

- Namespace all constants under `Flow`
- Add new state attribute DSL [#58](https://github.com/Freshly/flow/pull/58)
- Add a bunch of new custom matchers 
- `handle_errors` method for operations [#85](https://github.com/Freshly/flow/pull/85)
- Allow nil values for passed-in arguments [#68](https://github.com/Freshly/flow/pull/68)
- State accessors [#63](https://github.com/Freshly/flow/pull/63)
- Remove rewind functionality [#83](https://github.com/Freshly/flow/pull/83)
- Proactive failure guard clauses [#67](https://github.com/Freshly/flow/pull/67)
- Adopt `spicerack-styleguide` in favor of hand-rolled rubocop
- Fix double run bug [#98](https://github.com/Freshly/flow/pull/98)
- Externalize the base of state gem [#100](https://github.com/Freshly/flow/pull/100)

## 0.9.3

*Release Date*: 2019/4/10

- Add define_context matcher
- Update docs

## 0.9.2

*Release Date*: 2019/4/3

- Bump spicerack version

## 0.3.0

*Release Date*: 2018/12/10

- Added Spicerack gem
- Added logging around flows and operations

## 0.2.0

*Release Date*: 2018/12/2

- FlowBase
- StateBase
- OperationBase

## 0.1.0

*Release Date*: 2018/11/29

- Initial commit (blank project)
