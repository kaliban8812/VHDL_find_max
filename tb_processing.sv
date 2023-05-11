
`timescale 1ns/1ns

module tb_processing;

    parameter data_i_width = 23;
    parameter data_o_width = 13;

    logic clk_i = 0;
    logic rst_i;

    logic run_stb_i;
    logic [data_i_width:0] data_0_i, data_1_i, data_2_i, data_3_i;

    logic rdy_stb_o;
    logic [data_o_width:0] data_0_o, data_1_o, data_2_o, data_3_o;

    processing dut(
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .run_stb_i(run_stb_i), 
        .data_0_i (data_0_i ), 
        .data_1_i (data_1_i ), 
        .data_2_i (data_2_i ), 
        .data_3_i (data_3_i ), 
        .rdy_stb_o(rdy_stb_o), 
        .data_0_o (data_0_o ), 
        .data_1_o (data_1_o ), 
        .data_2_o (data_2_o ), 
        .data_3_o (data_3_o ) 
    );

////////////////////////////////////////
// clk_gen
////////////////////////////////////////   
    initial forever
        #10 clk_i = !clk_i;
    default clocking cb
        @(posedge clk_i);
    endclocking

////////////////////////////////////////
// read data from file
////////////////////////////////////////  
    parameter data_array_length = 8192;
    logic [data_i_width:0] test_data [data_array_length:0];
    initial begin
        $readmemb("D:/ADM_START_2/_PROCESSING/test_data_fbg.txt", test_data);
    end

////////////////////////////////////////
// sequence of actions
////////////////////////////////////////  
    initial begin
        $display("Start, time %d", $time);
        rst_i <= 1; ##10;
        rst_i <= 0; ##10;
        run_stb_i <= 1; ##1;
        run_stb_i <= 0;
        for (int i = 0; i <= data_array_length; i = i + 1) begin
            @(posedge clk_i);
            data_0_i <= test_data[i]; 
            data_1_i <= test_data[i];
            data_2_i <= test_data[i]; 
            data_3_i <= test_data[i]; 
        end
        ##1000;
        $display("End, time %d", $time);
        $stop;
    end

////////////////////////////////////////
// verify 
////////////////////////////////////////  
    logic [data_o_width:0] value_out_0 [$];
    logic [data_o_width:0] value_out_1 [$];
    logic [data_o_width:0] value_out_2 [$];
    logic [data_o_width:0] value_out_3 [$];
    logic rdy_stb_o_prev;

    always @(posedge clk_i)
    begin
        rdy_stb_o_prev <= rdy_stb_o;
        if (rdy_stb_o == 1)         begin
            value_out_0.push_back(data_0_o);
            value_out_1.push_back(data_1_o);
            value_out_2.push_back(data_2_o);
            value_out_3.push_back(data_3_o);
        end
    end

    initial begin
        wait ( (rdy_stb_o_prev == 1) & (rdy_stb_o == 0) );
        $display("LINE [0] = %p", value_out_0); 
        $display("LINE [1] = %p", value_out_1); 
        $display("LINE [2] = %p", value_out_2); 
        $display("LINE [3] = %p", value_out_3); 
    end

endmodule