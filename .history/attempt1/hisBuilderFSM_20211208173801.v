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
    output reg acq_count_finish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum

);
    reg [`BIN_NUM_PER_RAM : 1] BRAM [(`peakMax - 1) : 0] ;

    parameter RESET_ALL = 2'b00, INPUT_COUNT = 2'b01, PIXEL_COUNT = 2'b10, ACQ_COUNT = 2'b11;
    reg [1:0] current_state, next_state;
    reg [1:0] input_count = 0; //2
    reg [7:0] pixel_count = 0; //200
    reg [19:0] acq_count = 0; //33333
    reg input_count_finish, pixel_count_finish;//, acq_count_finish;
    reg inside_ress = 0;
    reg inside_resss = 0;
    reg inside_res;

    integer i;
    always @(posedge clk or negedge res or negedge inside_res) begin
        inside_res = ~(inside_ress & inside_resss);
        if ((~res) || (inside_res)) begin
            inside_ress <= 0;
            inside_resss <= 0;
            binCounts <= 0;
            // dataFinish <= 0;
            hisNum <= 0;

            input_count <= 0;
            input_count_finish <= 0;

            pixel_count <= 0;
            pixel_count_finish <= 0;

            acq_count <= 0;
            acq_count_finish <= 0;

            for (i = 1; i <= (`BIN_NUM_PER_RAM - 1)*(`peakMax - 1); i=i+1) begin
                BRAM[i] <= 0; //reset whole bram
            end 
        end
            else begin
                if (wrEn) begin
                    //BRAM[input_count + pixel_count*`ACQ_NUM + acq_count*(`PIXEL_NUM_PER_RAM)*(`ACQ_NUM)] = addr;
                    if (input_count < `DATA_NUM - 1) begin
                        input_count = input_count + 1;
                    end
                    else begin
                        input_count = 0;  
                        input_count_finish = 1;
                        if (pixel_count < `PIXEL_NUM_PER_RAM - 1) begin
                            pixel_count = pixel_count + 1;
                        end
                        else begin
                            pixel_count = 0;
                            pixel_count_finish = 1;
                            if (acq_count < `ACQ_NUM - 1) begin
                                acq_count = acq_count + 1;
                            end        
                            else begin
                                acq_count = 0;
                                inside_ress = 1;
                                acq_count_finish = 1;
                                hisNum = ~hisNum;
                            end 
                        end
                    end    

                end
            end

    end

    // always @(posedge clk or negedge res) begin
    //     if (~res) begin
    //         binCounts <= 0;
    //         // dataFinish <= 0;
    //         hisNum <= 0;

    //         input_count <= 0;
    //         input_count_finish <= 0;

    //         pixel_count <= 0;
    //         pixel_count_finish <= 0;

    //         acq_count <= 0;
    //         acq_count_finish <= 0;

    //         for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //             BRAM[i] = 0; //reset whole bram
    //         end 
    //     end
    //         else begin
    //         if (wrEn) begin
    //             if (~input_count_finish) begin
    //                 input_count = input_count + 1;
    //             end
    //             else input_count = 0;        

    //             if (input_count_finish == 1) begin
    //                 pixel_count = pixel_count + 1;
    //             end  

    //             if (pixel_count_finish == 1) begin
    //                 acq_count = acq_count + 1;
    //             end  

    //             if (acq_count_finish == 1) begin
    //                 pixel_count = pixel_count + 1;
    //                 binCounts <= 0;
    //                 // dataFinish <= 0;
    //                 hisNum <= 0;

    //                 input_count <= 0;
    //                 input_count_finish <= 0;

    //                 pixel_count <= 0;
    //                 pixel_count_finish <= 0;

    //                 acq_count <= 0;
    //                 acq_count_finish <= 0;

    //                 for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //                     BRAM[i] = 0; //reset whole bram
    //                 end 

    //                 hisNum = ~hisNum;
    //             end        
    //         end
    //         end
    // end

    // always @(*) begin
    //     if (input_count > `DATA_NUM - 1) begin
    //         input_count_finish = 1;
    //     end
    //     if (pixel_count > `PIXEL_NUM_PER_RAM - 1) begin
    //         pixel_count_finish = 1;
    //     end
    //     if (acq_count > `ACQ_NUM - 1) begin
    //         acq_count_finish = 1;
    //         hisNum = ~hisNum;
    //     end
    // end

    // always @(posedge clk or negedge res) begin
    //     if (~res) begin
    //         current_state = RESET_ALL;
    //     end
    //         else
    //         current_state <= next_state;
    // end

    // integer i;
    // always @(*) begin
    //     case (current_state)
    //         RESET_ALL:begin
    //             next_state = INPUT_COUNT;
    //         end 
    //         INPUT_COUNT:begin
    //             if (input_count_finish == 1) begin
    //                 next_state = PIXEL_COUNT;
    //             end
    //             else
    //             next_state = INPUT_COUNT;
    //         end
    //         PIXEL_COUNT:begin
    //             if (pixel_count_finish == 1) begin
    //                 next_state = ACQ_COUNT;
    //             end
    //             else 
    //             next_state = INPUT_COUNT;
    //         end
    //         ACQ_COUNT:begin
    //             if (acq_count_finish == 1) begin
    //                 next_state = RESET_ALL;
    //             end
    //             else 
    //             next_state = INPUT_COUNT;
    //         end
    //         default: next_state = RESET_ALL;
    //     endcase
    // end

    // always @(posedge clk or negedge res) begin
    //     if (~res) begin
    //         binCounts <= 0;
    //         // dataFinish <= 0;
    //         hisNum <= 0;

    //         input_count <= 0;
    //         input_count_finish <= 0;

    //         pixel_count <= 0;
    //         pixel_count_finish <= 0;

    //         acq_count <= 0;
    //         acq_count_finish <= 0;
    //     end
    //     else begin
    //         case (current_state)
    //             RESET_ALL:begin
    //                 for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //                     BRAM[i] = 0; //reset whole bram
    //                 end  

    //                 input_count <= 0;
    //                 input_count_finish <= 0;

    //                 pixel_count <= 0;
    //                 pixel_count_finish <= 0;

    //                 acq_count <= 0;
    //                 acq_count_finish <= 0;
    //             end 
    //             INPUT_COUNT:begin
    //                 input_count = input_count + 1;
    //                 if (input_count > `DATA_NUM - 1) begin
    //                     input_count_finish = 1;
    //                 end
    //             end
    //             PIXEL_COUNT:begin
    //                 pixel_count = pixel_count + 1;
    //                 input_count_finish <= 0;
    //                 input_count <= 0;
    //                 if (pixel_count > `PIXEL_NUM_PER_RAM - 1) begin
    //                     pixel_count_finish = 1;
    //                 end
    //             end
    //             ACQ_COUNT:begin
    //                 acq_count = acq_count + 1;
    //                 pixel_count_finish <= 0;
    //                 input_count_finish <= 0;
    //                 input_count <= 0;
    //                 pixel_count <= 0;
    //                 if (acq_count > `ACQ_NUM - 1) begin
    //                     acq_count_finish = 1;
    //                     hisNum = ~hisNum;
    //                 end
    //             end
    //             default: begin
    //                 for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //                     BRAM[i] = 0; //reset whole bram
    //                 end  
    //             end 
    //         endcase
    //     end
    // end
    
// `probe(BRAM);
endmodule