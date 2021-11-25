`include "parametersSiFH.vh"
// `define Nb 6
// `define Np 10
// `define peakMax 21
module peakDetecter
(
    input clk,
    input [`peakMax:0] NoC, 
    input [1:0] status,
    input [`peakMax:0] addr, 
    input reset, 
    output reg [`peakMax:0] peakCH, 
    output reg [`peakMax:0] peakFH
);
    reg [`peakMax : 0] recentMax = 0;
    reg [`peakMax : 0] addrSaver = 0;
    //reg outputEnable;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            peakCH <= 0;
            peakFH <= 0;
        end
        else begin
            recentMax <= (NoC > recentMax) ? NoC : recentMax;
            addrSaver <= (NoC > recentMax) ? addr : addrSaver;
                if (status == 2'b10) begin
                    peakCH <= addrSaver;
                    peakFH <= 0;
                end
                else begin
                    if (status == 2'b01) begin
                        peakCH <= 0;
                        peakFH <= addrSaver;
                    end
                    else begin
                            peakCH <= 0;
                            peakFH <= 0;
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
