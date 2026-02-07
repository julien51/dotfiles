---
name: check-pr
description: When you submit a PR (or push a change to a branch that already has a PR), wait for CI checks to perform, and process them.
---

Repeat the following loop until the PR is fully approved and CI is green:

1. **Check CI status** - Poll GitHub Actions until all checks complete
2. **If CI failed** - Investigate the failure, implement the minimal fix, push, and restart the loop
3. **Check reviews** - Look for comments from both human reviewers and agent reviewers
4. **If changes requested** - Implement the requested changes (only what's needed), push, and restart the loop
5. **Post a summary** - After each push, post a comment summarizing what you changed so reviewers (human and agent) can track your work

Keep iterating until:
- All CI checks pass
- All reviewer comments are addressed
- The PR is approved

Before each push, verify you're not introducing more changes than required.
