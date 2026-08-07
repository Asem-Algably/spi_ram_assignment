module spi_slave_tb ();

    reg clk;
    reg rst_n;

    // spi inputs
    reg mosi_i;
    reg ss_n_i;

    // ram inputs
    reg tx_valid_i;
    reg [7:0] tx_data_i;

    // spi outputs
    wire miso_o;

    // ram outputs
    wire rx_valid_o;
    wire [9:0] rx_data_o;

    spi_slave #(
        .SPI_MODE(0)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .MOSI_i(mosi_i),
        .SS_n_i(ss_n_i),
        .tx_valid_i(tx_valid_i),
        .tx_data_i(tx_data_i),
        .MISO_o(miso_o),
        .rx_valid_o(rx_valid_o),
        .rx_data_o(rx_data_o)
    );

    // Clock generation
    localparam CLK_PERIOD = 10; // Clock period in time units
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Testbench stimulus
    initial begin
        // Initialize inputs
        rst_n = 0;
        mosi_i = 0;
        ss_n_i = 1;
        tx_valid_i = 0;
        tx_data_i = 0;

        // Apply reset
        repeat (2) @(negedge clk);
        rst_n = 1;

        // Test sequence
        repeat (2) @(negedge clk);
        ss_n_i = 0; // Activate slave select

        // Send a write command (spi_command=01, ram_command=00, data=10101010) code = 10'h0aa
        send_spi_command(1'b0, 2'b00, 8'b10101010);
        @(negedge clk);

        // reset state
        ss_n_i = 1; 
        @(negedge clk);
        ss_n_i = 0;

        // Send a write command (spi_command=01, ram_command=00, data=11000011) code = 10'h1c3
        send_spi_command(1'b0, 2'b01, 8'b11000011);
        @(negedge clk);

        // reset state
        ss_n_i = 1; 
        @(negedge clk);
        ss_n_i = 0;

        // Send a read address command (spi_command=1, ram_command=10, data=10110101) code = 10'h2b5
        send_spi_command(1'b1, 2'b10, 8'b10110101);
        @(negedge clk);
        
        // reset state
        ss_n_i = 1; 
        @(negedge clk);
        ss_n_i = 0;

        // send a read data command (spi_command=1, ram_command=11, data=11010101)
        tx_valid_i = 1;
        tx_data_i = 8'b10110101;
        send_spi_command(1'b1, 2'b11, 8'b11010101);
        repeat (11) @(negedge clk);

        // reset state
        ss_n_i = 1; 
        @(negedge clk);
        ss_n_i = 0;

        // Finish simulation
        $stop;
    end

    // Task to send SPI command
    task send_spi_command(
        input fsm_command,
        input [1:0] ram_command,
        input [7:0] data);
        integer i;
        begin

            // send fsm command
            mosi_i = fsm_command;
            @(negedge clk);

            // send ram command
            for (i = 1; i >= 0; i = i - 1) begin
                mosi_i = ram_command[i];
                @(negedge clk);
            end

            // send data
            for (i = 7; i >= 0; i = i - 1) begin
                mosi_i = data[i];
                @(negedge clk);
            end

        end
    endtask

    // monitor outputs
    initial begin
        $monitor("Time: %0t | MISO_o: %b | rx_valid_o: %b | rx_data_o: %b", $time, miso_o, rx_valid_o, rx_data_o);
    end
endmodule