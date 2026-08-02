# RTL Coding Style Guide

**Project:** SPI RAM with SPI Slave Interface  
**Language:** Verilog-2001  
**Version:** 1.0

---

# 1. Purpose

This document defines the RTL coding style used throughout this project.

The objectives are to:

- Keep the code readable and maintainable.
- Ensure all modules follow a consistent style.
- Simplify debugging and code reviews.
- Reduce bugs caused by inconsistent coding practices.

Whenever possible, prioritize **clarity** over cleverness.

---

# 2. General Principles

- Every module should have one clear responsibility.
- Keep designs modular.
- Write code that another engineer can understand quickly.
- Prefer descriptive names over short names.
- Avoid unnecessary complexity.

---

# 3. File Naming

Use **snake_case** for all filenames.

Good

```
ram.v
spi_slave.v
spi_wrapper.v
```

Avoid

```
RAM.v
SPISlave.v
spiSlave.v
```

---

# 4. Module Naming

Module names shall match their filename.

Example

```verilog
module spi_slave (...);

endmodule
```

---

# 5. Signal Naming

## Inputs

All input signals shall end with `_i`.

Examples

```verilog
clk_i
rst_n_i
mosi_i
addr_i
```

---

## Outputs

All output signals shall end with `_o`.

Examples

```verilog
miso_o
ready_o
data_o
```

---

## Internal Signals

Use meaningful names.

Good

```verilog
shift_reg
bit_counter
write_enable
```

Avoid

```verilog
tmp
x
temp1
```

---

# 6. Clock and Reset

Clock name

```verilog
clk_i
```

Reset name

```verilog
rst_n_i
```

Active-low reset is preferred.

Reset logic should always appear first inside sequential blocks.

Example

```verilog
always @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i)
    begin
        state <= IDLE;
    end
    else
    begin
        state <= next_state;
    end
end
```

---

# 7. Parameters

Avoid hardcoded values whenever possible.

Parameter names shall use **UPPER_CASE**.

Good

```verilog
parameter DATA_WIDTH  = 8;
parameter ADDR_WIDTH  = 8;
parameter MEMORY_SIZE = 256;
```

Avoid

```verilog
parameter data_width = 8;
parameter addrWidth = 8;
```

Use parameters to improve module reusability.

---

# 8. State Machine Style

State machines should be written in a clear and consistent style across three parts

- state register

- next state logic

- output logic

State names shall be declared using `localparam`.

Example

```verilog
localparam IDLE      = 2'b00;
localparam RECEIVE   = 2'b01;
localparam TRANSMIT  = 2'b10;
```

The selected FSM style should remain consistent within the module.

---

# 9. Sequential Logic

Sequential logic shall use **non-blocking assignments (`<=`)**.

Example

```verilog
counter <= counter + 1;
```

---

# 10. Combinational Logic

Combinational logic shall use **blocking assignments (`=`)**.

Example

```verilog
next_state = IDLE;
```

---

# 11. Magic Numbers

Avoid unexplained numeric constants.

Bad

```verilog
if (counter == 7)
```

Good

```verilog
localparam BYTE_WIDTH = 8;

if (counter == BYTE_WIDTH - 1)
```

---

# 12. Comments

Comments should explain **why**, not **what**.

Good

```verilog
// Ignore writes while chip select is inactive.
```

Avoid

```verilog
// Increment counter
counter <= counter + 1;
```

Only comment code that is not immediately obvious.

---

# 13. Formatting

- Use **tabs** for indentation.
- Maximum line length: 100 characters.
- One statement per line.
- Leave one blank line between logical sections.

---

# 14. begin/end Usage

Always use `begin` and `end` with `if`, `else`, `for`, `while`, and branches, even when they contain only a single statement.

Good

```verilog
if (write_enable)
begin
    data <= data_i;
end
else
begin
    data <= data;
end
```

Avoid

```verilog
if (write_enable)
    data <= data_i;
else
    data <= data;
```

Using `begin` and `end` consistently reduces errors when modifying existing code.

---

# 15. Module Header

Every module should begin with a short description.

Example

```verilog
//-----------------------------------------------------
// Module:
//     SPI Slave
//
// Description:
//     Implements an SPI Mode-0 slave interface.
//-----------------------------------------------------
```

---

# 16. Port Declaration Order

Ports shall appear in the following order:

1. Clock
2. Reset
3. Inputs
4. Outputs

Example

```verilog
module spi_slave
(
    input clk_i,
    input rst_n_i,

    input mosi_i,
    input sclk_i,
    input cs_n_i,

    output miso_o
);
```

---

# 17. RTL Rules

The following are not permitted:

- Inferred latches.
- Multiple drivers for the same signal.
- Unused signals.
- Unused parameters.

---

# 18. TODO Comments

Temporary work should use the following format.

```verilog
// TODO:
// Add support for SPI Mode 3.
```

---

# 19. Naming Summary

| Item                          | Convention | Example       |
| ----------------------------- | ---------- | ------------- |
| File                          | snake_case | `spi_slave.v` |
| Module                        | snake_case | `spi_slave`   |
| Parameter                     | UPPER_CASE | `DATA_WIDTH`  |
| Localparam                    | UPPER_CASE | `IDLE`        |
| Input                         | `*_i`      | `clk_i`       |
| Output                        | `*_o`      | `miso_o`      |
| Internal Signal               | snake_case | `bit_counter` |
| Internal sequential signal    | `*_seq`    | `miso_o`      |
| Internal combinational signal | `*_comp`   | `bit_counter` |

---

# 20. Final Principle

Code should be written so that another engineer can understand its purpose without additional explanation.

Readable code is preferred over clever code.

---

# 21. One Module Per File

Each Verilog source file shall contain only one module.

The filename shall match the module name.

Example

```
ram.v
```

contains

```verilog
module ram;

...

endmodule
```

This simplifies navigation, code reviews, and project organization.

---

# 22. Default Assignments

Every combinational `always @(*)` block shall assign default values before any conditional logic.

Example

```verilog
always @(*)
begin
    next_state = state;
    write_enable = 1'b0;

    case (state)

        IDLE:
        begin
            if (start_i)
            begin
                next_state = RECEIVE;
            end
        end

        RECEIVE:
        begin
            write_enable = 1'b1;
        end

    endcase
end
```

Providing default assignments helps prevent unintended latch inference and makes the intended behavior explicit.
