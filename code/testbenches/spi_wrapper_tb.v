module spi_wrapper_tb ();
    //////////////////////////////////
    //---  uut_ports_and_parameters_declaration
    //////////////////////////////////
    parameter MEM_DEPTH = 256 ;
    parameter ADDR_SIZE = $clog2(MEM_DEPTH); // calculates the ADDR_SIZE automatically to reduce errors
    parameter PRE_DIN_SIZE = (ADDR_SIZE > 8)? ADDR_SIZE : 8 ; // choosing the bigger width between ram_width and ADDR_SIZE

    reg clk ;
    reg rst_n ;
    reg SS_n_i ;
    reg MOSI_i ;

    wire MISO_o ; 


    //////////////////////////////////
    //---  additional signals used in testbench
    //////////////////////////////////
    reg [(PRE_DIN_SIZE-1)+2:0] bits_to_be_sent ; // this signal is used to make it easier to transmit serial bits
    reg [ADDR_SIZE-1:0] write_address;
    reg [7:0] write_data;


    //////////////////////////////////
    //---  uut_instantiation
    //////////////////////////////////
    spi_wrapper 
    #(
        .MEM_DEPTH (MEM_DEPTH) 
    )
    uut_spi_wrapper
    (
        .clk (clk) ,
        .rst_n (rst_n), 

        .SS_n_i (SS_n_i), 
        .MOSI_i (MOSI_i), 

        .MISO_o (MISO_o) 
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

    integer i ;

    initial 
    begin
        //////////////////////////////////
        //---  initializing the mem
        //////////////////////////////////
        $readmemh("../code/testbenches/mem_8_256_all_zeros.dat",uut_spi_wrapper.inst_sp_syn_ram.mem) ; // u need to extend or shrink the mem.data file if u changed MEM_DEPTH


        //////////////////////////////////
        //---  test ___rst_n___ functionality
        //////////////////////////////////
        $info("test ___rst_n___ functionality");
        //drive
        rst_n = 0 ;
        SS_n_i = 1 ;
        MOSI_i = 0 ; 
        
        //wait then check
        @(negedge clk); // internal registers : all should be 0 
                        // went to IDLE state
        if(MISO_o !== 0 ) // used !== to take into considiration the x state in case any fault occured
        begin
            $display("rst_n error functoinality.");
            $stop;
        end


        // inside one repeat to check the functionallity by only locking at external ports 
        // this can be done by reading the same adderss u already wrote data on it 
        // the challenge is to minimize the time of simulation
        // so u need to calculate the num of clk cycles each operarion needs precisely 

        repeat(100)
        begin
            //////////////////////////////////
            //---  test ___00_holding_write_address___ functionality
            //////////////////////////////////
            $info("test ___00_holding_write_address___ functionality");
            //drive
            rst_n = 1 ;
            SS_n_i = 0 ;
            MOSI_i = 0 ; 
            @(negedge clk); // went to CHK_CMD state

            // SS_n_i = 0 ;
            // MOSI_i = 0 ; 
            @(negedge clk); // went to WRITE state

            bits_to_be_sent = {2'b00 , $random[(PRE_DIN_SIZE-1):0] };
            write_address = bits_to_be_sent[ADDR_SIZE-1:0] ;
            for ( i=(PRE_DIN_SIZE-1)+2 ; i>=0; i=i-1) 
            begin
                MOSI_i = bits_to_be_sent[i];
                @(negedge clk); // at each clk cycle the mosi sends one bit of the bits_to_be_sent from MSB to LSB
            end 

            SS_n_i = 1 ; 
            @(negedge clk); // went to IDLE state 
                            // internal signal : write_address_reg should equal write_address


            //////////////////////////////////
            //---  test ___01_writing_into_memory___ functionality
            //////////////////////////////////
            $info("test ___01_writing_into_memory___ functionality");
            //drive
            // rst_n = 1 ;
            SS_n_i = 0 ;
            MOSI_i = 0 ; 
            @(negedge clk); // went to CHK_CMD state

            // SS_n_i = 0 ;
            // MOSI_i = 0 ; 
            @(negedge clk); // went to WRITE state

            bits_to_be_sent = {2'b01 , $random[(PRE_DIN_SIZE-1):0] };
            write_data = bits_to_be_sent [7:0] ;
            for ( i=(PRE_DIN_SIZE-1)+2 ; i>=0; i=i-1) 
            begin
                MOSI_i = bits_to_be_sent[i];
                @(negedge clk); // at each clk cycle the mosi sends one bit of the bits_to_be_sent from MSB to LSB
            end 

            SS_n_i = 1 ; 
            @(negedge clk); // went to IDLE state 
                            // internal signal : mem[write_address_reg] should equal write_data


            //////////////////////////////////
            //---  test ___10_holding_read_address___ functionality
            //////////////////////////////////
            $info("test ___10_holding_read_address___ functionality");
            //drive
            // rst_n = 1 ;
            SS_n_i = 0 ;
            MOSI_i = 1 ; 
            @(negedge clk); // went to CHK_CMD state

            // SS_n_i = 0 ;
            // MOSI_i = 1 ; 
            @(negedge clk); // went to READ_ADD state

            bits_to_be_sent = {2'b10 , $random[(PRE_DIN_SIZE-1):0] }; // randomize all other bits 
            bits_to_be_sent[ADDR_SIZE-1:0] = write_address ;// overwrite the bits that will be used as read_address only 
                                                            // i wrote the last write_address 
                                                            // to make sure the write_data has been saved in the correctle in the righet place or not
                                                            // i will see it on the output port "MISO_o" the next operation
            for ( i=(PRE_DIN_SIZE-1)+2 ; i>=0; i=i-1) 
            begin
                MOSI_i = bits_to_be_sent[i];
                @(negedge clk); // at each clk cycle the mosi sends one bit of the bits_to_be_sent from MSB to LSB
            end 

            SS_n_i = 1 ; 
            @(negedge clk); // went to IDLE state 
                            // internal signal : read_address_reg should equal write_address
                            // in general read_address_reg should equal bits_to_be_sent[ADDR_SIZE-1:0]



            //////////////////////////////////
            //---  test ___11_reading_from_memory___ functionality
            //////////////////////////////////
            $info("test ___11_reading_from_memory___ functionality");
            //drive
            // rst_n = 1 ;
            SS_n_i = 0 ;
            MOSI_i = 1 ; 
            @(negedge clk); // went to CHK_CMD state

            // SS_n_i = 0 ;
            // MOSI_i = 1 ; 
            @(negedge clk); // went to READ_DATA state

            bits_to_be_sent = {2'b11 , $random[(PRE_DIN_SIZE-1):0] }; // randomize all other bits as it will not be used 
            for ( i=(PRE_DIN_SIZE-1)+2 ; i>=0; i=i-1) 
            begin
                MOSI_i = bits_to_be_sent[i];
                @(negedge clk); // at each clk cycle the mosi sends one bit of the bits_to_be_sent from MSB to LSB
            end 

            @(negedge clk); // internal signals : dout of the ram =  write_data sent before 
                                                // tx_valid of the ram = 1

            @(negedge clk); // internal signals : register in the spi_slave = write_data sent before
            
            $info("start checking the data out of the miso")
            for (i=(PRE_DIN_SIZE-1) ; i>=0; i=i-1)  
            begin   // during 10 clk cycles for the spi to convert dout from parallel to serial data
                    // data will be sent bit by bit at each clk cycle
                    // i will compare each bit sent on MISO_o with the "write_data" bits 
                    // which was sent before
                    // the module should send the MSBs first

                @(posedge clk);

                if (MISO_o != write_data[i])
                begin
                    $display("reading_from_memory error functionality.");
                    $stop;  // u can rely on the self checking to verify everything is perfect
                            // but if u faced a problem at this point 
                            // u need to debug all internal signals written above 
                            // specified in each step to determite which operation caused the problem 
                end
            end

            @(negedge clk); // drive at the negative edge 

            SS_n_i = 1 ; 
            @(negedge clk); // went to IDLE state 
            
        end

        $display("simulation ended.");
        $stop;
    end

    initial 
    begin
        $monitor("time: %0t | rst_n = %b | SS_n_i = %b | MOSI_i = %b | MISO_o = %b "
                ,$time , rst_n , SS_n_i ,MOSI_i,  MISO_o );
    end
endmodule



