`include "parametersSiFH.vh"

module  algebraicBlock(
    input peakCH,
    //input peakReady,
    output reg [`Nb:1] THminus,
    output reg [`Nb:1] THpositive,
    output reg [`Nb:1] delta
);

always @(peakReady ) begin
    
end
reg [`Nb:1] SB;
reg [`Np:1] CH;

assign SB = 1 << (`Nb - 1);
assign CH = peakCH << (`Np - `Nb);
assign THminus = CH - SB;
assign THpositive = CH + SB;
assign delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
    
endmodule