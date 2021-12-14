`include "parametersSiFH.vh"

module topAll
(
    input clk,
    input res, 
    input wrEn, //CH -> 2'b11 FH->2'b01
    input [`Nb:1] addr,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg acq_count_finish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum

);

    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0];
    reg [31:0] see;

    parameter RESET_ALL = 2'b00, INPUT_COUNT = 2'b01, PIXEL_COUNT = 2'b10, ACQ_COUNT = 2'b11;
    reg [1:0] current_state, next_state;
    reg [1:0] input_count = 0; //2
    reg [7:0] pixel_count = 0; //200
    reg [19:0] acq_count = 0; //33333
    reg input_count_finish, pixel_count_finish;//, acq_count_finish;
    reg inside_ress = 0;
    reg inside_resss = 0; //= 0;
    reg inside_res;
    reg wrEnn;
    reg combin_res;

    // assign binCounts = BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ];

    always @(*) begin
        see = addr  + pixel_count*`BIN_NUM_PER_HIS;
        inside_res = inside_ress && ~inside_resss; ///write into another always block
        combin_res = res||inside_res;
    end

    integer i;

    always @(negedge res) begin
        if (~res) begin
            hisNum <= 0;
        end
        else begin
            if (acq_count_finish) begin
                hisNum <= ~hisNum;
            end
            else begin
                hisNum <= 0;
            end
        end
    end
    always @(posedge clk or negedge combin_res) begin //combine res
        
        inside_resss <= inside_ress;
        
        wrEnn <= wrEn;
        if (combin_res) begin
   
            inside_ress <= 0; //!!!!!!!!!where to put this
            
            binCounts <= 0;
            // dataFinish <= 0;

            input_count <= 0;
            input_count_finish <= 0;

            pixel_count <= 0;
            pixel_count_finish <= 0;

            acq_count <= 0;
            acq_count_finish <= 0;

            for (i = 0; i < (`BIN_NUM_PER_RAM); i=i+1) begin
                BRAM[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
            end 
            // for (i = 1; i <= (`BIN_NUM_PER_RAM - 1); i=i+1) begin
            //     for (j = 1; j <= (`peakMax - 1); j=j+1) begin
            //         BRAM[i][j] <= 1'b0; //reset whole bram
            //     end 
            // end
        end
            else begin

            end

    end
endmodule