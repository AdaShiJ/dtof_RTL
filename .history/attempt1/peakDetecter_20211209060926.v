`include "parametersSiFH.vh"
// `define Nb 6
// `define Np 10
// `define peakMax 21
module peakDetecter
(
    input clk,
    input [`peakMax-1:0] NoC, 
    input hisNum,
    input acq_count_finish,
    //input [1:0] status,
    input [`Nb:1] addr, 
    input reset, //add a inner reset
    output reg [`Nb:1] peakCH, 
    output reg [`Nb:1] peakFH,
    output reg peakDone
);
    reg [`peakMax-1 : 0] recentMax = 0;
    reg [`Nb:1] addrSaver = 0;
    //reg outputEnable;
    always @(posedge clk or negedge reset or posedge acq_count_finish) begin
        if (~reset) begin
            peakCH <= 0;
            peakFH <= 0;
            recentMax <= 0;
            addrSaver <= 0;
            peakDone <= 0;
        end
        else begin
            recentMax <= (NoC > recentMax) ? NoC : recentMax;
            addrSaver <= (NoC > recentMax) ? addr : addrSaver;
            if (acq_count_finish) begin
                if (~hisNum) begin
                    peakCH <= addrSaver;
                    peakFH <= 0;
                    peakDone <= 1;
                end
                else begin
                    peakCH <= 0;
                    peakFH <= addrSaver;
                    peakDone <= 1;
                end
            end
        end
    end    


endmodule

// `include "parametersSiFH.v";
// module peakDetecterTB( 
//     input clk,
//     input [`peakMax:0] NoC, 
//     input addr, 
//     input reset, 
//     output [`peakMax:0] peakCH, 
//     output [`peakMax:0] peakFH
//     );
//     reg [`peakMax : 0] recentMax = 0;
//     reg outputEnable;
//     always @(postage clk) begin
//         if (reset) begin
//             peakCH <= 0;
//             peakFH <= 0;
//         end
//         else
//             recentMax <= (Noc > recentMax) ? Noc : recentMax;
//     end
// endmodule
