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

assign reg [`Nb:1] SB = 1<<(`Nb-1);
assign reg [`Np:1] CH = peakCH<<(`NP - `Nb);
assign reg THminus = CH - SB;
assign reg THpositive = CH + SB;
assign reg delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
    
endmodule