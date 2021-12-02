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

assign reg SB = 1<<(`Nb-1);
assign reg CH = peakCH<<(`NP - `Nb);
assign reg THminus = CH - SB;
assign reg THpositive = CH + SB;
assign reg delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
    
endmodule