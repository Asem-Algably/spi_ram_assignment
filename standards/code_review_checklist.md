# Code Review Checklist

**Project:** SPI RAM with SPI Slave Interface  
**Version:** 1.0

---

# Purpose

This checklist defines the minimum set of items that shall be verified before approving a Pull Request.

The objective is to improve code quality, maintain consistency, and reduce defects before integration into the `main` branch.

---

# Review Checklist

## RTL Design

- [ ] The implementation satisfies the Issue requirements.
- [ ] The design behaves as intended.
- [ ] No obvious functional bugs were found.
- [ ] The implementation does not introduce unintended side effects.

---

## Coding Standards

- [ ] The RTL follows the project's coding style guide.
- [ ] Signal and module names follow the naming conventions.
- [ ] Parameters and localparams use the required naming convention.
- [ ] The code is properly formatted.

---

## Readability

- [ ] The code is easy to understand.
- [ ] Logic is organized into clear sections.
- [ ] Comments are meaningful and explain non-obvious behavior.
- [ ] No unnecessary or duplicate logic exists.

---

## RTL Quality

- [ ] No inferred latches.
- [ ] Sequential logic uses non-blocking assignments (`<=`).
- [ ] Combinational logic uses blocking assignments (`=`).
- [ ] Default assignments are present where required.
- [ ] Magic numbers have been avoided where practical.

---

## Verification

- [ ] The contributor verified the design locally.
- [ ] Relevant testbenches have been updated if required.
- [ ] Existing functionality has not been broken.

---

## Documentation

- [ ] Documentation has been updated if required.
- [ ] Public interfaces match the documentation.

---

## Pull Request

- [ ] The Pull Request solves a single Issue.
- [ ] The Pull Request description clearly explains the changes.
- [ ] The associated Issue is referenced.

---

# Review Outcome

## Approve

Approve the Pull Request if:

- All required checks pass.
- No blocking issues remain.
- The implementation is ready for integration.

---

## Request Changes

Request changes if:

- Functional bugs are identified.
- Coding standards are violated.
- Verification is insufficient.
- Documentation is incomplete.
- The implementation does not satisfy the Issue requirements.

---

# Review Principles

When reviewing code:

- Review the code, not the author.
- Be respectful and constructive.
- Explain the reason behind requested changes.
- Suggest improvements when possible.
- Prefer discussion over assumptions.

The goal of code review is to improve the project, not to criticize contributors.


