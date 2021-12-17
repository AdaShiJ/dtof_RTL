`include "parametersSiFH.vh"

module  DF(
    input [`Np:1] roughData,
    input [`Np:1] THminus,
    input [`Np:1] THpositive,
    input [`Np:1] delta,
    input hisNum,
    output reg [`Nb:1] data
);
reg [`Np:1] interData;
always @(*) begin
    if (hisNum == 0) begin //only the first Nb bits is read
        data = roughData[`Np:(`Np-`Nb+1)];
        interData = 0;
    end
    else begin
        if ((roughData>=THminus) && (roughData<=THpositive))begin
            interData = roughData>delta? (roughData - delta):0;
            data = interData[`Np:(`Np-`Nb+1)];
        end
    end
end
endmodule