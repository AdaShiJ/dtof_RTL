`include "parametersSiFH.vh"

module  algebraicBlock(
    input [`Nb:1] peakCH,
    input peakDone,
    //input peakReady,
    output reg [`Np:1] THminus,
    output reg [`Np:1] THpositive,
    output reg [`Np:1] delta,
    output reg algebraicReady
);

reg [`Np:1] TTHminus;
reg [`Np:1] TTHpositive;
reg [`Np:1] SB;
reg [`Np:1] CH;
reg [`Np:1] upperBound;
reg [`Nb:1] upperBoundCH;
reg algebraicReadyy;

always @(*) begin
    upperBound = ~0;
    upperBoundCH = ~0;
    SB = 1 << (`Nb - 1) + 1 << (`Nb - 2); //use the middle value of bin
    CH = peakCH << (`Np - `Nb);
    TTHminus <= CH - SB;//bound
    TTHpositive <= CH + SB;//bound
    if (CH >=  (upperBound - SB)) begin
        TTHpositive <= upperBound - upperBoundCH;//wtf
        TTHminus <= TTHpositive - 2* SB;
    end
    else begin
        if (CH <=  SB) begin
            TTHminus <= 0;
            TTHpositive <= TTHminus + 2* SB;
        end
        else begin
            TTHpositive <= CH + SB;//wtf
            TTHminus <= CH - SB;
        end
    end

    THminus <= TTHminus;//[`Np:`Np-`Nb+1];
    THpositive <= TTHpositive;//[`Np:`Np-`Nb+1];
    delta <= THminus + THpositive - (THpositive >> `Nb) << `Nb ;
    algebraicReady <= algebraicReadyy;
end
    
endmodule