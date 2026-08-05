module sp_syn_ram_tb ();
    //////////////////////////////////
    //---  uut_ports_and_parameters_declaration
    //////////////////////////////////
    parameter MEM_DEPTH = 256 ;
    parameter ADDR_SIZE = $clog2(MEM_DEPTH); // calculates the ADDR_SIZE automatically to reduce errors
    parameter PRE_DIN_SIZE = (ADDR_SIZE > 8)? ADDR_SIZE : 8 ; // choosing the bigger width between ram_width and ADDR_SIZE

    reg clk ;
    reg rst_n ;

    reg [(PRE_DIN_SIZE-1)+2:0] din_i ; // adding 2 bits to deremine ram_operations
                                      // note: if ADDR_SIZE != ram width u have to handle the extra dummy bits sent
    reg rx_valid_i ;

    wire [7:0] dout_o ; // the ram_width = 8 bits
    wire tx_valid_o ; 

    //////////////////////////////////
    //---  uut_instantiation
    //////////////////////////////////
    sp_syn_ram 
    #(
        .MEM_DEPTH (MEM_DEPTH) 
    )
    uut_sp_syn_ram
    (
        .clk (clk) ,
        .rst_n (rst_n), 

        .din_i (din_i), 

        .rx_valid_i (rx_valid_i), 

        .dout_o (dout_o), 
        .tx_valid_o (tx_valid_o)
    );

    //////////////////////////////////
    //---  clk_generation
    //////////////////////////////////
    localparam T = 10 ;
    always 
    begin
        clk = 0 ;
        forever 
        begin
            #(T/2) clk= ~clk ;    
        end
    end

    //////////////////////////////////
    //---  moment_of_truth
    //////////////////////////////////
    initial 
    begin
        //////////////////////////////////
        //---  initializing the mem
        //////////////////////////////////
        $readmemh("../code/testbenches/mem_8_256.dat",uut_sp_syn_ram.mem) ; // u need to extend or shrink the mem.data file if u changed MEM_DEPTH


        //////////////////////////////////
        //---  test ___rst_n___ functionality
        //////////////////////////////////
        $info("test ___rst_n___ functionality");
        //drive
        rst_n = 0 ;
        din_i = $random ;
        rx_valid_i = 0 ; 
        
        //wait then check
        @(negedge clk); // internal registers :write_address_reg=0 , read_address_reg=0 
        if(dout_o !== 0 || tx_valid_o !== 0 )
        begin
            $display("rst_n error functoinality.");
            $stop;
        end


        //////////////////////////////////
        //---  test ___00_holding_write_address___ functionality
        //////////////////////////////////
        $info("test ___00_holding_write_address___ functionality");
        //drive
        rst_n = 1 ;
        din_i [(PRE_DIN_SIZE-1)+2:(PRE_DIN_SIZE-1)+1] = 2'b00 ; 

        repeat(20)
        begin
            din_i [(PRE_DIN_SIZE-1):0] = $random ; // it should only hold the bits of address size only
            rx_valid_i = $random ; 

            //wait then check
            @(negedge clk); // internal signal : write_address_reg should equal din_i [(ADDR_SIZE-1):0] if rx_valid_i = 1
                            // otherwise ramains the previous value
        end


        //////////////////////////////////
        //---  test ___01_writing_into_memory___ functionality
        //////////////////////////////////
        $info("test ___01_writing_into_memory___ functionality");
        //drive
        // rst_n = 1 ;
        din_i [(PRE_DIN_SIZE-1)+2:(PRE_DIN_SIZE-1)+1] = 2'b01 ; 

        repeat(20)
        begin
            din_i [(PRE_DIN_SIZE-1):0] = $random ; // it should only store the  8 bits of memory size only
            rx_valid_i = $random ; 

            //wait then check
            @(negedge clk); // internal memory : mem[write_address_reg] should equal din_i [7:0] if rx_valid_i = 1
                            // otherwise ramains the previous value
                            // note : it will be using the last address hold in write_address_reg
        end


        //////////////////////////////////
        //---  test ___10_holding_read_address___ functionality
        //////////////////////////////////
        $info("test ___10_holding_write_address___ functionality");
        //drive
        rst_n = 1 ;
        din_i [(PRE_DIN_SIZE-1)+2:(PRE_DIN_SIZE-1)+1] = 2'b10 ; 

        repeat(20)
        begin
            din_i [(PRE_DIN_SIZE-1):0] = $random ; // it should only hold the bits of address size only
            rx_valid_i = $random ; 

            //wait then check
            @(negedge clk); // internal signal : read_address_reg should equal din_i [(ADDR_SIZE-1):0] if rx_valid_i = 1
                            // otherwise ramains the previous value
        end


        //////////////////////////////////
        //---  test ___11_reading_from_memory___ functionality
        //////////////////////////////////
        $info("test ___11_reading_from_memory___ functionality");
        //drive
        // rst_n = 1 ;
        din_i [(PRE_DIN_SIZE-1)+2:(PRE_DIN_SIZE-1)+1] = 2'b11 ; 

        repeat(20)
        begin
            din_i [(PRE_DIN_SIZE-1):0] = $random ; // it should deal with it as dummy bits
            rx_valid_i = $random ; 

            //wait then check
            @(negedge clk); 
                            // tx_valid_o should equal 1 if rx_valid_i = 1
                            // otherwise = 0

                            // dout_o should equal mem[read_address_reg] if rx_valid_i = 1   
                            // otherwise ramains the previous value
                            // note : it will be using the last address hold in read_address_reg
        end





        $display("simulation ended.");
        $stop;
    end

    initial 
    begin
        $monitor("time: %0t | rst_n = %b | din_i = %b | rx_valid_i = %b | dout_o = %b | tx_valid_o = %b "
                ,$time , rst_n , din_i ,rx_valid_i,  dout_o , tx_valid_o);
    end
endmodule



