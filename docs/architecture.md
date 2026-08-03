# System Architecture

**Project:** SPI RAM with SPI Slave Interface  
**Version:** 1.0

---

# Overview

This project implements a simple memory module that communicates with an external SPI Master using the Serial Peripheral Interface (SPI).

The system receives commands serially through the SPI interface, decodes them, and performs memory read or write operations accordingly. Data read from memory is transmitted back to the SPI Master through the MISO line.

The design is divided into three main modules to improve modularity, readability, and maintainability.

---

# Top-Level Architecture

```
                 +----------------------+
                 |      SPI Master      |
                 +----------+-----------+
                            |
          +-----------------+-----------------+
          |   MOSI   MISO   SS_n   CLK         |
          |                                     |
          v
                +----------------------+
                |    SPI Wrapper       |
                |----------------------|
                |                      |
                |  +---------------+   |
                |  |  SPI Slave    |   |
                |  +-------+-------+   |
                |          |           |
                |          |           |
                |  +-------v-------+   |
                |  |     RAM       |   |
                |  +---------------+   |
                +----------------------+
```

---

# Module Description

## SPI Wrapper

The SPI Wrapper is the top-level module of the project.

It connects the SPI Slave interface to the RAM module and controls the communication between them.

Its responsibilities include:

- Instantiating the SPI Slave and RAM modules.
- Routing data and control signals between the modules.
- Providing the external SPI interface.

---

## SPI Slave

The SPI Slave module handles all SPI communication.

Its responsibilities include:

- Receiving serial data from the MOSI line.
- Detecting SPI transactions.
- Decoding received commands.
- Converting serial data into parallel data.
- Transmitting read data serially through the MISO line.

The SPI Slave does not access memory directly. Instead, it communicates with the RAM through a simple parallel interface.

---

## RAM

The RAM module stores user data.

Its responsibilities include:

- Storing incoming data.
- Returning stored data during read operations.
- Receiving commands and addresses from the SPI Slave.

The RAM operates using a synchronous interface.

---

# Data Flow

## Write Operation

1. The SPI Master sends a write command.
2. The SPI Slave receives and decodes the serial data.
3. The SPI Wrapper forwards the decoded information to the RAM.
4. The RAM stores the received data.

---

## Read Operation

1. The SPI Master sends a read command.
2. The SPI Slave decodes the request.
3. The SPI Wrapper requests the required data from the RAM.
4. The RAM returns the requested data.
5. The SPI Slave serializes the data.
6. The SPI Master receives the data through the MISO line.

---

# Design Principles

The project follows a modular architecture.

Each module has a single responsibility:

| Module      | Responsibility                       |
| ----------- | ------------------------------------ |
| SPI Wrapper | Connects and coordinates all modules |
| SPI Slave   | Handles SPI communication            |
| RAM         | Stores and retrieves data            |

This separation simplifies verification, debugging, and future modifications.

---

# Repository Documentation

The project documentation is divided as follows:

| Document        | Description                 |
| --------------- | --------------------------- |
| architecture.md | Overall system architecture |
| spi_wrapper.md  | SPI Wrapper module          |
| spi_slave.md    | SPI Slave module            |
| ram.md          | RAM module                  |
| verification.md | Verification strategy       |

---

# Notes

This architecture is intentionally modular to allow each block to be developed, verified, and maintained independently.

Future projects may reuse individual modules or extend the system with additional functionality while preserving the same architectural principles.
