`include "parametersSiFH.vh"

module hisBuilderFSM
(
    input clk,
    input res, 
    input wrEn, //CH -> 2'b11 FH->2'b01
    input [`Nb:1] addr,
    //input hisNum, add the data processing part all in DF
    //output reg nextFlag,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg dataFinish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum

);
    reg [`BIN_NUM_PER_RAM : 1] BRAM [(`peakMax - 1) : 0];


    parameter RESET_ALL = 2'b00, INPUT_COUNT = 2'b01, PIXEL_COUNT = 2'b10, ACQ_COUNT = 2'b11;
    reg current_state, next_state;
    reg [1:0] input_count; //2
    reg [7:0] pixel_count; //200
    reg [19:0] acq_count; //30000
    reg input_count_finish, pixel_count_finish, acq_count_finish;

    always @(posedge clk or negedge res) begin
        if (~res) begin
            current_state = RESET_ALL;
        end
            else
            current_state <= next_state;
    end

    integer i;
    always @(current_state) begin
        case (current_state)
            REST_ALL:begin
                next_state = INPUT_COUNT;
            end 
            INPUT_COUNT:begin
                if (input_count_finish == 1) begin
                    next_state = PIXEL_COUNT;
                end
                else
                next_state = INPUT_COUNT;
            end
            PIXEL_COUNT:begin
                if (pixel_count_finish == 1) begin
                    next_state = ACQ_COUNT;
                end
                else 
                next_state = INPUT_COUNT;
            end
            ACQ_COUNT:begin
                if (acq_count_finish == 1) begin
                    next_state = REST_ALL;
                end
                else 
                next_state = INPUT_COUNT;
            end
            default: next_state = RESET_ALL;
        endcase
    end

    always @(posedge clk or negedge res) begin
        if (~res) begin
            binCounts <= 0;
            dataFinish <= 0;
            hisNum <= 0;
        end
        else begin
            case (current_state)
                REST_ALL:begin
                    for (i = 1; i <= `RAM_SIZE; i=i+1) begin
                        BRAM[i] = 0; //reset whole bram
                    end  
                end 
                INPUT_COUNT:begin
                    
                end
                default: begin
                    for (i = 1; i <= `RAM_SIZE; i=i+1) begin
                        BRAM[i] = 0; //reset whole bram
                    end  
                end 
        endcase
        end
    end
    

endmodule