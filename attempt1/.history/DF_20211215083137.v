`include "parametersSiFH.vh"

module  DF(
    input [`Np - 1:0] roughData,
    input [`Np - 1:0] THminus,
    input [`Np - 1:0] THpositive,
    input [`Np - 1:0] delta,
    input hisNum,
    output reg [`Nb - 1:0] data
);
reg [`Np - 1:0] interData;
always @(*) begin
    if (hisNum == 0) begin //only the first Nb bits is read
        data = roughData[`Np:(`Np-`Nb+1)];
        interData = 0;
    end
    else begin
        if ((roughData>=THminus) && (roughData<=THpositive))begin
            interData = roughData>delta? (roughData - delta):0;
            data = interData[`Nb - 1:0];//[`Np:(`Np-`Nb+1)];
        end
        else
            data = 0;
    end
end
endmodule