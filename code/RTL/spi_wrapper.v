//-----------------------------------------------------
// Module:
//     spi_wrapper
//
// Description:
//     Top-level module that integrates the SPI slave
//     interface with the single-port synchronous RAM.
//
//     The wrapper connects the SPI slave and RAM modules,
//     routing commands received over the SPI interface to
//     the RAM and returning read data back to the SPI
//     master. Memory-related parameters are propagated to
//     the underlying modules to ensure a consistent system
//     configuration.
//-----------------------------------------------------
module spi_wrapper 
    #(
    parameter MEM_DEPTH = 256 ,
    parameter ADDR_SIZE = $clog2(MEM_DEPTH), // calculates the ADDR_SIZE automatically to reduce errors
    parameter PRE_DIN_SIZE = (ADDR_SIZE > 8)? ADDR_SIZE : 8  // choosing the bigger width between ram_width and ADDR_SIZE
    )
    (
    input clk ,
    input rst_n ,

    input SS_n_i ,
    input MOSI_i ,

    output MISO_o
    );

    wire [(PRE_DIN_SIZE-1)+2:0] din_i ;
    wire rx_valid_i ;
    wire [7:0] dout_o ;
    wire tx_valid_o ;
    
    sp_syn_ram 
    #(
        .MEM_DEPTH (MEM_DEPTH) 
    )
    inst_sp_syn_ram
    (
        .clk (clk) ,
        .rst_n (rst_n), 

        .din_i (din_i), 

        .rx_valid_i (rx_valid_i), 

        .dout_o (dout_o), 
        .tx_valid_o (tx_valid_o)
    );


    spi_slave 
    #(
        .MEM_DEPTH (MEM_DEPTH) 
    )
    inst_spi_slave
    (
        .clk (clk) ,
        .rst_n (rst_n), 
        // activation signal
        .SS_n_i (SS_n_i), 

        // inputs
        .MOSI_i (MOSI_i), 
        .tx_data_i (dout_o), 
        .tx_valid_i (tx_valid_o), 


        // outputs
        .rx_data_o (din_i), 
        .rx_valid_o (rx_valid_i), 
        .MISO_o (MISO_o)

    );


endmodule
