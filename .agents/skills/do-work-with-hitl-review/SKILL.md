---
name: do-work-with-hitl-review
description: "Execute a unit of work through validation but stop before committing — let the human review first. Use when user wants agent-assisted implementation with human-in-the-loop review before any git operations, or says 'implement but let me review'."
---

# Do Work (Human-in-the-Loop Review)

Execute a unit of work through validation, then pause for human review. No commits, no pushes, no PRs.

For the fully automated variant (with commit/push/PR), see `do-work`.

## Workflow

### Steps 1–5: Core workflow

Follow all steps in [../do-work/WORKFLOW.md](../do-work/WORKFLOW.md).

### 6. Report & pause

Once build and tests pass:

1. Summarize what was implemented and which files changed
2. List any decisions or trade-offs made during implementation
3. Note any concerns or areas that may need human attention
4. **STOP.** Do not commit, push, or create a PR
5. Ask the user to review the changes and confirm next steps
