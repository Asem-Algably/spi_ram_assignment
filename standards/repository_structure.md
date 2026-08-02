# Repository Structure

**Project:** SPI RAM with SPI Slave Interface  
**Version:** 1.0

---

# Purpose

This document defines the repository structure used throughout the project.

A consistent repository structure improves readability, simplifies navigation, and ensures that contributors know where each type of file belongs.

---

# Repository Layout

```
SPI_RAM_project_template/
│
├── code/
│   ├── RTL/
│   ├── constraints/
│   ├── scripts/
│   │   └── waveforms/
│   └── testbenches/
│
├── docs/
│
├── questa projects/
│
├── standards/
│
├── .gitignore
└── README.md
```

---

# Directory Description

## code/

Contains all source code and files required to design, verify, and implement the project.

---

### RTL/

Contains all synthesizable Verilog modules.

Example

```
ram.v
spi_slave.v
spi_wrapper.v
```

---

### testbenches/

Contains all simulation testbenches.

Example

```
ram_tb.v
spi_slave_tb.v
spi_wrapper_tb.v
```

Testbench files shall not contain synthesizable logic.

---

### constraints/

Contains FPGA constraint files.

Example

```
spi_wrapper.xdc
```

---

### scripts/

Contains scripts used during development.

Examples include:

- QuestaSim simulation scripts
- Vivado TCL scripts
- Automation scripts

Scripts should automate repetitive development tasks whenever practical.

---

### scripts/waveforms/

Contains waveform configuration files used by QuestaSim.

These files define the signals displayed during simulation and improve debugging consistency across contributors.

Waveform configuration files are part of the project and should be committed to the repository.

---

## docs/

Contains all project documentation.

Examples include:

- Project architecture
- Module documentation
- Verification documentation

Documentation should be updated whenever interfaces or behavior change.

---

## questa projects/

Contains locally generated QuestaSim and Questa Lint project files.

This directory is intended only for local development.

Its contents are ignored by Git using the project's `.gitignore` file and shall not be committed to the repository.

---

## standards/

Contains the engineering standards followed by the project.

Current standards include:

- RTL Coding Style
- Git Workflow
- Code Review Checklist
- Documentation Standards
- Repository Structure

Every contributor is expected to follow these standards.

---

## .gitignore

Defines files and directories that should not be tracked by Git.

Examples include:

- Questa project files
- Simulation output files
- Temporary files
- Tool-generated artifacts

---

## README.md

Provides a high-level overview of the project.

Typical contents include:

- Project description
- Features
- Repository structure
- Getting started
- Build and simulation instructions

---

# Repository Principles

The repository should contain only files required to:

- Design the project
- Verify the project
- Document the project
- Collaborate effectively

Tool-generated files should not be committed unless they are required by all contributors.

---

# Final Principle

Every file in the repository should have a clear purpose and an appropriate location.

A clean and consistent repository structure makes collaboration easier and allows the project to scale as it grows.
