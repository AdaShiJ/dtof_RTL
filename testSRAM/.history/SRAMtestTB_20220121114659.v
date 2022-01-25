SRAMtest SRAMtest(
    //.QA,
    .QB(rdata),
    .ADRA(addra),
    .DA(wdata),
    .WEA(wea),
    .MEA(mea), //memory enable
    .CLKA(clka),
    .TEST1A(1'b0),
    .RMEA(1'b0),
    .RMA(3'b0),
    .LS(1'b0),
    .ADRB(addrb),
    //.DB,
    //.WEB,
    .MEB(meb),
    .CLKB(clkb),
    .TEST1B(1'b0),
    .RMEB(3'b0),
    .RMB(1'b0)
);

//write in port a and read with port b