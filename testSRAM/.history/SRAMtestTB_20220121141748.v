module tb (
    // ports
);

reg clk;
reg [20:0] rdata;
reg [5:0] addra;
reg [20:0] wdata;
reg wea;
reg mea;
reg clka;
reg [5:0] addrb;
reg meb;
reg clkb;



initial clk = 0;
always #1 clk = ~clk;

initial begin
    clk = 1'b0;
    forever begin
        
    end
end
    
endmodule

SRAMtest SRAMtest(
    //.QA, 
    .QB(rdata), //
    .ADRA(addra), //
    .DA(wdata), //
    .WEA(wea), //
    .MEA(mea), //memory enable
    .CLKA(clka), //
    .TEST1A(1'b0),
    .RMEA(1'b0),
    .RMA(4'b0),
    .LS(1'b0),
    .ADRB(addrb),
    //.DB,
    //.WEB,
    .MEB(meb),
    .CLKB(clkb),
    .TEST1B(1'b0),
    .RMEB(1'b0),
    .RMB(4'b0)
);

//write in port a and read with port b