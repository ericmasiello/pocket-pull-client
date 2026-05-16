---
name: do-work
description: "Execute a unit of work end-to-end: branch, plan, implement, validate, commit, push, and open a pull request. Use when user wants autonomous work — build a feature, fix a bug, or implement a plan phase with full git automation."
---

# Do Work (Full Auto)

Execute a complete unit of work: branch, plan, build, validate, commit, push, open PR.

For the human-in-the-loop variant (no commit/push/PR), see `do-work-with-hitl-review`.

## Workflow

### Steps 1–5: Core workflow

Follow all steps in [WORKFLOW.md](WORKFLOW.md).

### 6. Commit

Once build and tests pass, commit the work with a clear, conventional commit message.

### 7. Push & open PR

1. Push the branch:
   ```bash
   git push -u origin HEAD
   ```

2. Open a pull request targeting `main`:
   - Write a descriptive title summarizing the change
   - Write a body that explains what changed, why, and how to verify
   - If linked to a GitHub issue, include `Closes #<issue-number>` in the body
   ```bash
   gh pr create --title "<title>" --body "<body>"
   ```

3. Report the PR URL to the user.
