module sp_syn_ram 
    #(
    parameter MEM_DEPTH = 256 ,
    parameter ADDR_SIZE = $clog2(MEM_DEPTH), // calculates the ADDR_SIZE automatically to reduce errors
    parameter PRE_DIN_SIZE = (ADDR_SIZE > 8)? ADDR_SIZE : 8  // choosing the bigger width between ram_width and ADDR_SIZE
    )
    (
    input clk ,
    input rst_n ,

    input [(PRE_DIN_SIZE-1)+2:0] din_i , // adding 2 bits to deremine ram_operations
                                         // note: if ADDR_SIZE != ram_width u have to handle the extra dummy bits sent
    input rx_valid_i ,

    output reg [7:0] dout_o , // the ram_width = 8 bits
    output reg tx_valid_o 
    );
    
    
    reg [7:0] mem [MEM_DEPTH-1:0];
    reg [ADDR_SIZE-1:0] write_address_reg ; 
    reg [ADDR_SIZE-1:0] read_address_reg ; 


    always @(posedge clk ) 
    begin
        if (~rst_n)
        begin
            write_address_reg <= 0 ;
            read_address_reg <= 0 ;
            dout_o <= 0 ;
            tx_valid_o <= 0 ;
        end
        else 
        begin
            tx_valid_o <= 0 ; // we need tx_valid_o to be high for only one clk cycle

            if(rx_valid_i)
            begin
                case (din_i [(PRE_DIN_SIZE-1)+2:(PRE_DIN_SIZE-1)+1])
                    2'b00:
                    begin
                        write_address_reg <= din_i [(ADDR_SIZE-1):0] ;
                    end 
                    2'b01:
                    begin
                        mem[write_address_reg] <=  din_i [7:0] ;
                    end 
                    2'b10:
                    begin
                        read_address_reg <= din_i [(ADDR_SIZE-1):0] ;
                    end 
                    2'b11:
                    begin
                        dout_o <= mem[read_address_reg] ;
                        tx_valid_o <= 1 ;
                    end 
                endcase
              
            end
                
        end
    end


endmodule

////////////// in case the design needs sp_asyn_ram \\\\\\\\\\\\\\\\\\\\\
/*    
module sp_asyn_ram 
    #(
    parameter MEM_DEPTH = 256 ,
    parameter ADDR_SIZE = $clog2(MEM_DEPTH), // calculates the ADDR_SIZE automatically to reduce errors
    parameter PRE_DIN_SIZE = (ADDR_SIZE > 8)? ADDR_SIZE : 8  // choosing the bigger width between ram_width and ADDR_SIZE
    )
    (
    input clk ,
    input rst_n ,

    input [(PRE_DIN_SIZE-1)+2:0] din_i , // adding 2 bits to deremine ram_operations
                                      // note: if ADDR_SIZE != ram_width u have to handle the extra dummy bits sent
    input rx_valid_i ,

    output reg [7:0] dout_o , // the ram_width = 8 bits
    output reg tx_valid_o 
    );
    
    
    reg [7:0] mem [MEM_DEPTH-1:0];
    reg [ADDR_SIZE-1:0] address_reg ; // read or write


    //////////////////////////////////
    //---  address_reg
    //////////////////////////////////
    always @(posedge clk or negedge rst_n) 
    begin
        if (~rst_n)
        begin
            address_reg <= 0 ;
        end
        else 
        begin
            //note: the ram will store the address if the pre_MSB of din_i = 0 //remember : 00 and 10
            if(rx_valid_i & ~din_i [(PRE_DIN_SIZE-1)+1])
            begin
                address_reg <= din_i [(ADDR_SIZE-1):0] ;
            end
        end
    end


    //////////////////////////////////
    //--- ram_operations 
    //////////////////////////////////
    always @(*) 
    begin
        // note: the output can be asyn without any problem
        // since i do not need to keep ist previous value for more than one cyle
        // since i need it for only one clock cycle while rx_valid_i =1
        // then it will be captured at the next clk edge by the spi slave
        dout_o = 0 ;            // to prevent un_inintional_latch
        tx_valid_o = 0 ;        // to prevent un_inintional_latch

        if(rx_valid_i)
        begin
            if( ~din_i [(PRE_DIN_SIZE-1)+2] & din_i [(PRE_DIN_SIZE-1)+1] ) // 01
            begin
                mem[address_reg] =  din_i [7:0] ;
            end
            if( din_i [(PRE_DIN_SIZE-1)+2] & din_i [(PRE_DIN_SIZE-1)+1] ) // 11
            begin
                dout_o = mem[address_reg] ;
                tx_valid_o = 1 ;
            end
        end
    end


endmodule
*/