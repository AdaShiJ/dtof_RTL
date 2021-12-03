`timescale 10ns/100ps
`include "parametersSiFH.vh"
//`include "peakDetecter.v"
module algebraicBlockTB (
    //ports
);
    reg [`Nb:1] peakCH;
    wire [`Nb:1] THminus;
    wire [`Nb:1] THpositive;
    wire [`Nb:1] delta;

    reg clk;
    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        
        #20
        peakCH = 6'd63;
        #20
        peakCH = 6'd1;
        #20
        peakCH = 6'd24;

    end

algebraicBlock  algebraicBlockU0(
    .peakCH(peakCH),
    .THminus(THminus),
    .THpositive(THpositive),
    .delta(delta)
);

endmodule