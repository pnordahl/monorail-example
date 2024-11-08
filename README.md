# An example `monorail` monorepo

This repo demonstrates how `monorail`s design enables fast parallel execution across a polyglot monorepo, using existing language tools.

## Requirements

This demonstrates a monorepo with c++, go, and rust. Make sure you have `g++`, `go`, and `cargo` installed, in addition to `jq` for friendly formatting of the JSON output from `monorail`.

## Running commands for all targets

Before continuing, open a separate shell and run `monorail log tail --stdout --stderr` to live-tail logs from all subsequent `monorail run` invocations. You can also query the most recent run log with `monorail log show --stdout --stderr`.

When you clone this repo, none of the targets will be changed. You can see this yourself by running `monorail analyze --target-groups | jq`, which will display no targets or target groups. Because all of the targets in this example repo depend on `proto`, add a newline to the `proto/addressbook.proto` file, save, and re-analyze:

```sh
monorail analyze --target-groups | jq
```
```json
{
  "timestamp": "2024-11-05T02:18:27.525499+00:00",
  "targets": [
    "c++/hello",
    "go",
    "go/project1",
    "go/project2",
    "proto",
    "rust",
    "rust/crate1",
    "rust/crate2",
    "rust/crate3"
  ],
  "target_groups": [
    [
      "proto",
      "go",
      "rust"
    ],
    [
      "rust/crate1",
      "rust/crate2",
      "rust/crate3",
      "go/project1",
      "go/project2",
      "c++/hello"
    ]
  ]
}
```

The `target_groups` array is built from your `uses` declarations in `Monorail.json`, and informs `monorail`s parallel execution plan. The first array of targets that will be executed for contains just "proto", "go", and "rust", and the final group contains all remaining targets. Each successive array that is processed for a given command unlocks the next array to execute, and all targets within an array are executed in parallel.

So, all of the following commands will run for all targets with appropriate dag-guided parallelism.

### Building

`monorail run -c build | jq`

### Testing

`monorail run -c test | jq`

Use the arg API to provide additional runtime arguments for a single command and target:

`monorail run -c test -t rust/crate1 --arg another_one`

... or use the arg-map API for more flexibility and use with multi-target, multi-command use cases:

```sh
monorail run -c lint build test --arg-map='{
  "rust/crate1": {
    "test": [
      "another_one"
    ]
  }
}'
```

... or save the arg map JSON to a file and use that instead:

`monorail run -c lint build test --arg-map-file=my_arg_map.json`

### Doing both with a sequence

`monorail run -s dev | jq`

### Cleaning

`monorail run -c clean | jq`

## Updating the checkpoint

`monorail checkpoint update -p | jq`

When you run this command, the starting point for change detection is moved to the HEAD commit, and any unstaged/staged changes that aren't yet committed will be stored in the checkpoint. Now if you run `monorail analyze --target-groups`, no targets will appear.

Edit the `go/project1/main.go` and `rust/crate1/src/lib.rs` files by adding a newline to each, and see how this change cascades through the dependency graph with `monorail analyze --target-groups | jq`. Then, you can run commands against just these changed targets as before with `monorail run -s dev | jq`.

You can also bypass the graph and run commands against targets directly, but beware of the dependency graph you are bypassing by doing so. To do this, pass a list of targets to run: `monorail run -c clean -t rust | jq`.

## Deleting the checkpoint

You can remove `monorail`s checkpoint `monorail checkpoint delete | jq`. Doing this removes the starting point marker for change detection, as well as the list of pending files and their SHA2 checksums.

## Setting the checkpoint

You can decide where the checkpoint should be by using `monorail checkpoint update -i <sha>`. This is especially useful when you want to incrementally build/test subsets of changed targets since some previous point in history, e.g. a successful CI run.
