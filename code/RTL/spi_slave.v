//-----------------------------------------------------
// Module:
//     spi_slave
//
// Description:
//     Implements a parameterizable SPI slave interface
//     supporting SPI Modes 0 through 3.
//
//     The module receives SPI commands from the master,
//     decodes read and write transactions, and interfaces
//     with the RAM through a simple request/response
//     protocol. Received commands and data are forwarded
//     to the RAM using rx_data_o and rx_valid_o, while
//     read data returned by the RAM is transmitted back
//     to the SPI master through MISO_o.
//
//     The SPI operating mode is selected using the
//     SPI_MODE parameter, allowing the same module to be
//     reused for different CPOL/CPHA configurations.
//-----------------------------------------------------
module spi_slave #(
    parameter SPI_MODE = 0, // 0: CPOL=0, CPHA=0; 1: CPOL=0, CPHA=1; 2: CPOL=1, CPHA=0; 3: CPOL=1, CPHA=1
    parameter MEM_DEPTH = 256 // depth of the RAM
)(
    input clk,
    input rst_n,

    // spi inputs
    input MOSI_i,
    input SS_n_i,

    // ram inputs
    input tx_valid_i,
    input [7:0] tx_data_i,

    // spi outputs
    output reg MISO_o,

    // ram outputs
    output reg rx_valid_o,
    output reg [9:0] rx_data_o
);
    localparam SHIFT_REG_SIZE = 11; // 1 bit for command + 10 bits for data/address
    reg [SHIFT_REG_SIZE-1:0] spi_input_shift_reg_seq;
    reg [SHIFT_REG_SIZE-1:0] spi_output_shift_reg_seq;
    reg [4:0] bit_count_seq;
    reg read_address_obtained_seq;
    reg [7:0] ram_data_word_seq; // the data received from the ram

    wire mosi_sampled_comb = spi_input_shift_reg_seq[0]; // sampled data of the MOSI line

    // SPI parameters and registers
    localparam IDLE = 3'b000;
    localparam CHK_CMD = 3'b001;
    localparam WRITE = 3'b010;
    localparam READ_ADD = 3'b011;
    localparam READ_DATA = 3'b100;

    reg [2:0] current_state_seq, next_state_seq;

    // State Memory
    always @(posedge clk) begin
        if (!rst_n) begin
            current_state_seq <= IDLE;
        end else begin
            current_state_seq <= next_state_seq;
        end
    end

    // next state logic
    always @(posedge clk) begin
        case(current_state_seq)
            IDLE: begin
                if (!SS_n_i) begin
                    next_state_seq <= CHK_CMD;
                end else begin
                    next_state_seq <= IDLE;
                end
            end
            CHK_CMD: begin
                if (SS_n_i) begin
                    next_state_seq <= IDLE;
                end else if (mosi_sampled_comb) begin
                    if(read_address_obtained_seq) begin
                        next_state_seq <= READ_DATA;
                    end else begin
                        next_state_seq <= READ_ADD;
                    end
                end else begin
                    next_state_seq <= WRITE;
                end
            end
            WRITE: begin
                if (SS_n_i) begin
                    next_state_seq <= IDLE;
                end else begin
                    next_state_seq <= current_state_seq;
                end
            end
            READ_ADD: begin
                if (SS_n_i) begin
                    next_state_seq <= IDLE;
                end else begin
                    next_state_seq <= current_state_seq;
                end
            end
            READ_DATA: begin
                if (SS_n_i) begin
                    next_state_seq <= IDLE;
                end else begin
                    next_state_seq <= current_state_seq;
                end
            end
            default: next_state_seq <= IDLE;
        endcase
    end


//--------------------------------------------------------------------------
//                   output logic
// the output is split into two operations
// 1. the output and the operations related to the spi interface
// 2. the output and the operations related to the ram interface
//--------------------------------------------------------------------------


    //---------------------- SPI shift register logic ----------------------
    generate
        if (SPI_MODE == 0 | SPI_MODE == 3) begin : spi_mode_0_3
            // sample on rising edge of clk for SPI mode 0 and 3 and shift on falling edge of clk
            always @(posedge clk) begin
                if (!rst_n) begin
                    spi_input_shift_reg_seq <= 0;
                    spi_output_shift_reg_seq <= 0;
                    bit_count_seq <= 0;
                end else if (!SS_n_i) begin
                    // MSB is stored first, so we shift left and fill with the new bit from MOSI
                    spi_input_shift_reg_seq <= {spi_input_shift_reg_seq[SHIFT_REG_SIZE-2:0], MOSI_i};

                    // don't increment bit_count_seq beyond 11, as we only need to capture 11 bits (1 command + 10 data/address)
                    // the counter is allowed to reach 12 to stop any logic that depends on it reaching 11
                    if(bit_count_seq <= 4'd12) begin
                        bit_count_seq <= bit_count_seq + 1;
                    end

                end else begin
                    spi_input_shift_reg_seq <= 0;
                    bit_count_seq <= 0;
                end
            end
            
            always @(negedge clk) begin
                if (!rst_n) begin
                    MISO_o <= 0;
                end else if (!SS_n_i) begin
                    MISO_o <= spi_output_shift_reg_seq[SHIFT_REG_SIZE-1]; // MSB of the shift register is the data to be sent out
                    if (current_state_seq == READ_DATA && bit_count_seq == 4'd11) begin // read data command
                        spi_output_shift_reg_seq[SHIFT_REG_SIZE-1:2] <= {ram_data_word_seq}; // load the data from RAM into the output shift register
                    end else begin
                        spi_output_shift_reg_seq <= {spi_output_shift_reg_seq[SHIFT_REG_SIZE-2:0], 1'b0}; // shift right and fill with 0
                    end
                end else begin
                    MISO_o <= 0;
                end
            end
        end else begin : spi_mode_1_2
            // sample on falling edge of clk for SPI mode 1 and 2 and shift on rising edge of clk
            always @(negedge clk) begin
                if (!rst_n) begin
                    spi_input_shift_reg_seq <= 0;
                    spi_output_shift_reg_seq <= 0;
                    bit_count_seq <= 0;
                end else if (!SS_n_i) begin
                    // MSB is stored first, so we shift left and fill with the new bit from MOSI
                    spi_input_shift_reg_seq <= {spi_input_shift_reg_seq[SHIFT_REG_SIZE-2:0], MOSI_i};
                    // don't increment bit_count_seq beyond 11, as we only need to capture 11 bits (1 command + 10 data/address)
                    if(bit_count_seq < 4'd11) begin
                        bit_count_seq <= bit_count_seq + 1;
                    end
                end else begin
                    spi_input_shift_reg_seq <= 0;
                    bit_count_seq <= 0;
                end
            end
            
            always @(posedge clk) begin
                if (!rst_n) begin
                    MISO_o <= 0;
                end else if (!SS_n_i) begin
                    MISO_o <= spi_output_shift_reg_seq[SHIFT_REG_SIZE-1]; // MSB of the shift register is the data to be sent out
                    if (current_state_seq == READ_DATA && bit_count_seq == 4'd11) begin // read data command
                        spi_output_shift_reg_seq[SHIFT_REG_SIZE-1:2] <= {ram_data_word_seq}; // load the data from RAM into the output shift register
                    end else begin
                        spi_output_shift_reg_seq <= {spi_output_shift_reg_seq[SHIFT_REG_SIZE-2:0], 1'b0}; // shift right and fill with 0
                    end 

                end else begin
                    MISO_o <= 0;
                end
            end
        end
    endgenerate


    //----------------------- ram interface logic -----------------------

    always @(posedge clk) begin

        rx_valid_o <= 0; // default value
        rx_data_o <= spi_input_shift_reg_seq[SHIFT_REG_SIZE-2:0]; // the value to be sent to the RAM
        // read_address_obtained_seq is the last 10 bits of the shift register (excluding the command bit)

        if (!rst_n) begin
            read_address_obtained_seq <= 0;
        end else if (current_state_seq == WRITE && bit_count_seq == 4'd11) begin // write command
            read_address_obtained_seq <= 0;
            rx_valid_o <= 1; // indicate that the write data is valid and can be sent to the RAM
        end else if (current_state_seq == READ_ADD && bit_count_seq == 4'd11) begin // read address command
            read_address_obtained_seq <= 1;
            rx_valid_o <= 1; // indicate that the read address is valid and can be sent to the RAM
        end if (current_state_seq == READ_DATA && bit_count_seq == 4'd11) begin // read data command
            read_address_obtained_seq <= 0;
        end 
    end

    
    //-------------- storing the data received from memory --------------
    always @(posedge clk) begin
        if (!rst_n) begin
            ram_data_word_seq <= 0;
        end else if (tx_valid_i) begin
            ram_data_word_seq <= tx_data_i;
        end
    end

endmodule