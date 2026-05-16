# Core Workflow

Shared steps for `do-work` and `do-work-with-hitl-review`.

## 1. Branch check

```bash
git branch --show-current
```

If on `main`:
1. Identify the GitHub issue number from the task context
2. Create and switch to a feature branch:
   ```bash
   git checkout -b <issue-number>-<short-description>
   ```
   Example: `git checkout -b 42-add-dark-mode`

If no issue number is available, ask the user before creating a branch.

If already on a feature branch, continue on it.

## 2. Understand the task

Read any referenced plan or PRD. Explore the codebase to understand the relevant files, patterns, and conventions. If the task is ambiguous, ask the user to clarify scope before proceeding.

## 3. Plan the implementation (optional)

If the task has not already been planned, create a plan for it.

## 4. Implement

**For backend code**: use red/green/refactor, one test at a time in a tracer-bullet style.

1. Write a single failing test for the smallest vertical slice of behavior
2. Run the test — confirm it fails (red)
3. Write the minimum code to make it pass (green)
4. Repeat from step 1 for the next slice of behavior
5. Refactor if needed while keeping tests green

Each test should target one thin vertical slice through the system. Do not write all tests upfront — write one, make it pass, then move to the next.

**For UI code**: implement directly without TDD.

## 5. Validate

Run the feedback loops and fix any issues. Repeat until both pass cleanly.

```bash
xcodebuild -project "Pocket Pull.xcodeproj" -scheme "Pocket Pull" -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -quiet build 2>&1

xcodebuild test -project "Pocket Pull.xcodeproj" -scheme "Pocket Pull" -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:"Pocket PullTests" 2>&1
```
