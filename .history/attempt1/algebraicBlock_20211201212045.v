`include "parametersSiFH.vh"

module  algebraicBlock(
    input peakCH,
    input acqFinish,
    output reg THminus,
    output reg THpositive,
    output reg delta
);

assign reg SB = 1<<(`Nb-1);
assign reg CH = peakCH<<(`NP - `Nb);
assign reg THminus = CH - SB;
assign reg THpositive = CH + SB;
assign reg delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
    
endmodule