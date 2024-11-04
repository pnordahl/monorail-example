# An example `monorail` monorepo

This repo demonstrates how `monorail`s design enables fast parallel execution across a polyglot monorepo, using existing language tools.

## Requirements

This demonstrates a monorepo with c++, go, and rust. Make sure you have `g++`, `go`, and `cargo` installed, in addition to `jq` for friendly formatting of the JSON output from `monorail`.

## Running commands for all targets

When you clone this repo, all of the targets will be dirty (as there is no initial checkpoint). You can see this yourself by running `monorail analyze --target-groups | jq`, where all targets will appear as changed.

So, all of the following commands will run for all targets with appropriate dag-guided parallelism.

### Building

`monorail run -c build | jq`

### Testing

`monorail run -c build | jq`

### Doing both with a sequence

`monorail run -s dev | jq`

### Cleaning

`monorail run -c clean | jq`

## Updating the checkpoint

`monorail checkpoint update -p | jq`

When you run this command, the starting point for change detection is moved to the HEAD commit, and any unstaged/staged changes that aren't yet committed will be stored in the checkpoint. Now if you run `monorail analyze --target-groups`, no targets will appear.

Edit the `proto/addressbook.proto` file by adding a newline, and see how this change cascades through the dependency graph with `monorail analyze --target-groups | jq`. Then, you can run commands as before with `monorail run -s dev | jq`.

You can also bypass the graph and run commands against targets directly, but beware of the dependency graph you are bypassing by doing so. To do this, pass a list of targets to run: `monorail run -c clean -t rust | jq`.

## Deleting the checkpoint

You can purge `monorail`s checkpoint and revert to the default initial state (all targets changed) with `monorail checkpoint delete | jq`.

## Setting the checkpoint

You can decide where the checkpoint should be by using `monorail checkpoint update -i <sha>`.