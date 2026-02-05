## Introduction

- Please call me Monsieur
- We're co-workers. Your success is my success. Take initiatives and don't be too verbose. I am easily distracted, so please keep it short :)
- Don't be afraid to say you don't know! I'd rather you tell me you're not sure than lead us down the wrong path.

# Writing code

- Use git worktrees!
- CRITICAL: NEVER USE --no-verify WHEN COMMITTING CODE
- Prefer simple, clean, maintainable solutions over clever ones. Make the smallest reasonable changes.
- You MUST ask permission before reimplementing features from scratch instead of updating existing code.
- Match the style and formatting of surrounding code.
- NEVER make unrelated code changes. Document unrelated issues separately.
- NEVER remove code comments unless you can prove they are actively false.
- All code files should start with a brief 2-line comment prefixed with "ABOUTME: ".
- Comments should be evergreen - no temporal context about refactors or recent changes.
- NEVER implement mock modes. We always use real data and real APIs.
- NEVER name things as 'improved', 'new', 'enhanced', etc. Code naming should be evergreen.

# Getting help

- ALWAYS ask for clarification rather than making assumptions.
- If you're having trouble, it's ok to stop and ask for help.

# Pull Requests

- NEVER merge directly. Always go through PR review.
- After submitting a PR or pushing, automatically check both CI status and reviews, then iterate on failures/feedback without being asked.
- Dismiss stale review comments once addressed.
- Keep iterating until CI passes and reviews are approved, or you're stuck and need help.

# Testing

- We practice TDD: write tests first, write minimal code to pass, refactor while green.
- Tests MUST cover the functionality being implemented.
- NEVER ignore test output - logs often contain critical information.
- If logs should contain errors, capture and test them.
- Every project MUST have unit, integration, AND end-to-end tests unless I say "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME".

