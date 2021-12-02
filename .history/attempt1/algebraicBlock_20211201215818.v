`include "parametersSiFH.vh"

module  algebraicBlock(
    input peakCH,
    //input peakReady,
    output reg [`Nb:1] THminus,
    output reg [`Nb:1] THpositive,
    output reg [`Nb:1] delta
);

// always @(peakReady ) begin
    
// end
reg [`Nb:1] SB;
reg [`Np:1] CH;

always @(*) begin
    SB = 1 << (`Nb - 1);
    CH = peakCH << (`Np - `Nb);
    THminus = CH - SB;
    THpositive = CH + SB;
    delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
end
    
endmodule