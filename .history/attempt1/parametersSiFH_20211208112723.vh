`define Nb 6
`define Np 10
`define peakMax 21
`define ACQ_NUM 2
`define DATA_NUM 2
`define SRAM_NUM 2  
`define PIXEL_NUM 6
`define PIXEL_NUM_PER_RAM (`PIXEL_NUM / `SRAM_NUM)
`define BIN_NUM_PER_RAM (`PIXEL_NUM / `SRAM_NUM)
`define RAM_SIZE (`peakMax * `NUM_PER_RAM * `PIXEL_PER_RAM)
`define ACQ_NUM_PER_RAM (`ACQ_NUM * `PIXEL_PER_RAM)
`define PIXEL_PER_RAM 3

// `define Nb 6
// `define Np 10
// `define NumberOfBins 64//2^(Nb)
// `define peakMax 21
// `define ACQ_NUM 4//33333
// `define DATA_NUM 2
// `define SRAM_NUM 2//200
// `define PIXEL_NUM 6//32000//200*160
// `define NUM_PER_RAM (2^(`Nb))
// `define PIXEL_PER_RAM (`PIXEL_NUM / `SRAM_NUM)
// `define RAM_SIZE (`peakMax * `NUM_PER_RAM * `PIXEL_PER_RAM)
// `define ACQ_NUM_PER_RAM (`ACQ_NUM * `PIXEL_PER_RAM)//33333
