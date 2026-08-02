# Documentation Standards

**Project:** SPI RAM with SPI Slave Interface  
**Version:** 1.0

---

# Purpose

This document defines the documentation standards used throughout the project.

Every RTL module shall have a corresponding Markdown (`.md`) file describing its purpose, interface, implementation, and usage.

Documentation should be updated whenever the design changes.

---

# General Guidelines

- Every RTL module shall have its own documentation file.
- Keep documentation synchronized with the RTL.
- Explain the design instead of repeating the code.
- Use simple and concise language.
- Add diagrams only when and whenever they improve understanding.

---

# Module Documentation Structure

Each module document should contain the following sections.

## 1. Overview

Briefly describe the module and its purpose within the project.

---

## 2. Interface

Describe:

- Inputs
- Outputs
- Parameters (if any)

Explain the purpose of each signal.

---

## 3. Internal Operation

Describe how the module works internally.

Focus on the main ideas rather than RTL implementation details.

---

## 4. Usage

Describe how the module should be connected and any assumptions required for correct operation.

---

## 5. Notes

Document any important limitations, assumptions, or special behavior.

---

# Project Documentation

The repository should also include:

- **architecture.md** – High-level system architecture and module interactions.
- **verification.md** – Verification strategy and testbench overview.

---

# Final Principle

Documentation should allow a contributor to understand and use a module without reading the RTL first.
