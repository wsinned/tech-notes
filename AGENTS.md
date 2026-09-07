# Agent Guidelines

## Scope and Precedence

- These instructions apply to the entire repository.
- A more specific `AGENTS.md` in a subdirectory overrides this file for that subtree.
- Follow explicit user instructions first, then the most specific applicable repository instructions.
- Read `README*`, `CONTRIBUTING*`, relevant manifests, and CI configuration before changing established workflows.

## Repository Preflight

Before commencing each new task:

- Inspect `git status --short --branch`, the current branch, configured remotes, its upstream, and outgoing commits.
- Fetch the relevant remote and pull tracked changes with `git pull --ff-only` when the current state makes that safe.
- Never auto-stash, reset, discard, or switch away from uncommitted work. Stop and ask when local changes or divergence could be disturbed.
- If the current branch is not `main` or the configured default branch, check its upstream and outgoing commits and report its publication state.
- Ask whether the new task belongs on the current branch or needs a new descriptive branch.
- Compare a topic branch with the fetched remote default branch and report its ahead/behind counts. If the branch is behind or diverged, stop and ask whether to rebase, merge the default branch, or deliberately continue without synchronising. Apply only the explicit choice; never treat behind status as informational or rewrite published history without approval.
- When starting from `main`, update it with a fast-forward-only pull when safe, then create a descriptive topic branch after approval before changing files.

## Working Practices

- Make the smallest correct change that satisfies the request.
- Preserve existing architecture, naming, style, and user-visible behaviour unless the task explicitly changes them.
- Avoid speculative abstractions, unrelated refactors, and compatibility layers without a demonstrated need.
- Preserve unrelated user changes in the working tree.
- Ask before adding dependencies, changing public interfaces, or introducing migrations.

## Correctness and Safety

- Validate external input and return useful, contextual errors.
- Never add credentials, tokens, private keys, or sensitive personal data to source, fixtures, logs, or commits.
- Add or update regression tests for bug fixes and user-visible behaviour changes.
- Respect the platforms and runtime versions the repository claims to support.
- Update documentation, examples, configuration references, and command help when their behaviour changes.

## Verification

- Discover the repository’s canonical formatting, linting, testing, type-checking, and build commands from its documentation, manifests, task runner, and CI configuration.
- Run the narrowest relevant checks during development, then the full applicable checks before declaring completion.
- Do not claim a check passed unless it was run successfully.
- Report skipped or failing checks with the exact reason and likely impact.

## Git Workflow

- Work on a descriptive branch; never commit directly to `main` or another protected default branch.
- Keep commits focused on one logical change and include related tests and documentation.
- After completing and verifying requested repository changes, always commit them, push the topic branch, and create or update a pull request so the owner can review from another device. Do not leave completed work only as uncommitted local changes.
- Fetch immediately before pushing and compare the topic branch with the remote default branch. If it is behind or diverged, stop and obtain an explicit rebase, merge, or publish-without-synchronising decision.
- Never amend published history or force-push unless the owner explicitly requests it and the exact target is confirmed.
- Never merge, tag, release, deploy, or delete branches without explicit owner approval.

## Completion

- Summarise what changed and why.
- List the checks run and their results.
- Link the pull request and report its checks or review state.
- Call out remaining risks, assumptions, follow-up work, and any files intentionally left unchanged.
