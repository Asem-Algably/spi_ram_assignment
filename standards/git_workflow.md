# Git Workflow

**Project:** SPI RAM with SPI Slave Interface  
**Version:** 1.0

---

# 1. Purpose

This document defines the Git workflow used throughout this project.

The objectives are to:

- Keep the `main` branch stable.
- Encourage small, reviewable changes.
- Ensure every change is reviewed before integration.
- Maintain a clean and understandable project history.

Every contributor is expected to follow this workflow.

---

# 2. Workflow Overview

Every feature shall follow the workflow below.

```
Issue
    │
    ▼
Assign Contributor
    │
    ▼
Create Feature Branch
    │
    ▼
Implement Feature
    │
    ▼
Local Verification
    │
    ▼
Commit Changes
    │
    ▼
Push Branch
    │
    ▼
Open Pull Request
    │
    ▼
Code Review
    │
    ▼
Address Review Comments
    │
    ▼
Approval
    │
    ▼
Merge into main
    │
    ▼
Delete Branch
    │
    ▼
Close Issue
```

No code shall be committed directly to the `main` branch.

---

# 3. Repository Branches

## main

The `main` branch shall always contain stable and working code.

Direct commits to `main` are prohibited.

All modifications shall be introduced through Pull Requests.

---

## Feature Branches

Every issue shall be implemented in its own feature branch.

Branch naming convention:

```
feature/<feature_name>
```

Examples

```
feature/spi_slave
feature/ram
feature/wrapper
feature/read_command
feature/write_command
feature/ram_tb
```

Feature branches should remain focused on a single task.

---

# 4. GitHub Issues

Every development task shall begin with a GitHub Issue.

Issues provide:

- Task description
- Discussion
- Progress tracking
- Assignment

Example

```
#3 Implement SPI Slave

Assigned to:
John

Labels:
rtl
enhancement

Milestone:
v0.1
```

---

# 5. Development

Before beginning work:

1. Switch to `main`.
2. Pull the latest changes.
3. Create a new feature branch.

Example

```bash
git checkout main
git pull origin main
git checkout -b feature/spi_slave
```

Development should occur only on the feature branch.

---

# 6. Commits

Commits should represent logical units of work.

Commit messages should clearly describe the change.

Good examples

```
Implement SPI receiver

Add RAM write logic

Fix address decoding

Improve wrapper readability
```

Avoid

```
update

changes

fix

test
```

Commit messages should be concise and written in the imperative mood.

---

# 7. Local Verification

Before opening a Pull Request, contributors should verify that:

- The design compiles.
- Simulation completes successfully.
- The implemented functionality matches the issue requirements.
- Coding standards are followed.

---

# 8. Pull Requests

Each Pull Request shall:

- Resolve one GitHub Issue.
- Target the `main` branch.
- Include only related changes.

The Pull Request description should include:

- Summary of changes
- Testing performed
- Related Issue

Example

```
Closes #3
```

---

# 9. Code Review

Every Pull Request shall be reviewed by another contributor.

The reviewer should verify:

- RTL correctness.
- Compliance with coding standards.
- Readability.
- Testbench quality.
- Documentation updates.
- Local verification results.

If improvements are required, review comments should clearly describe the requested changes.

---

# 10. Updating a Pull Request

If review comments are received:

1. Modify the feature branch.
2. Commit the changes.
3. Push the branch.

The Pull Request updates automatically.

A new Pull Request should not be created.

---

# 11. Approval

A Pull Request may be approved only after:

- Requested changes have been addressed.
- Review is complete.
- Local verification has been completed.

---

# 12. Merging

After approval:

- Merge the Pull Request into `main`.
- Delete the feature branch.
- Close the associated GitHub Issue.

The `main` branch should remain stable after every merge.

---

# 13. Branch Protection

The `main` branch should be protected using GitHub Branch Protection Rules.

Recommended settings:

- Require Pull Requests before merging.
- Require at least one approval.
- Prevent direct pushes to `main`.

---

# 14. Repository Synchronization

Before beginning any new task:

```bash
git checkout main
git pull origin main
```

Always create new feature branches from the latest version of `main`.

---

# 15. Merge Conflicts

If merge conflicts occur:

- Resolve the conflicts locally.
- Verify that functionality is preserved.
- Re-run simulations if necessary.
- Commit the resolved changes.
- Push the updated branch.

Merge conflicts should never be resolved without understanding the affected code.

---

# 16. Repository Hygiene

After a Pull Request has been merged:

- Delete the feature branch.
- Ensure the associated Issue is closed.
- Pull the latest version of `main` before beginning the next task.

---

# 17. Final Principle

The purpose of this workflow is to ensure that every contribution is:

- Planned
- Implemented
- Verified
- Reviewed
- Documented

A consistent workflow improves collaboration, code quality, and project maintainability.
