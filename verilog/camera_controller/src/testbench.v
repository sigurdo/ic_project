//-----------------------------------------------------------------------------
//
// Title       : testbench
// Design      : camera_controller
// Author      : sigurdht
// Company     : NTNU
//
//-----------------------------------------------------------------------------
//
// File        : C:\Users\Sigurd\OneDrive - NTNU\elsys\semester5\ic\ic_project\verilog\camera_controller\src\testbench.v
// Generated   : Tue Nov  3 15:07:12 2020
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//{{ Section below this comment is automatically maintained
//   and may be overwritten
//{module {testbench}}
module testbench ();

//}} End of automatically maintained section

// -- Enter your statements here -- //

reg init;
reg exp_increase;
reg exp_decrease;
reg clk;
reg rst;

wire NRE_1;
wire NRE_2;
wire ADC;
wire expose;
wire erase;

camera_controller camera_controller1(init, exp_increase, exp_decrease, clk, rst, NRE_1, NRE_2, ADC, expose, erase);

initial begin
    clk = 0;
    rst = 0;
    exp_increase = 0;
    exp_decrease = 0;
    init = 0;
    #1
    exp_increase = 1;
    #10
    exp_increase = 0;
    exp_decrease = 1;
    #10
    $finish;
end

always begin
    #0.5    
    clk = ~clk;
end
  
endmodule
