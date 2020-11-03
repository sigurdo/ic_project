//-----------------------------------------------------------------------------
//
// Title       : camera_controller
// Design      : camera_controller
// Author      : sigurdht
// Company     : NTNU
//
//-----------------------------------------------------------------------------
//
// File        : C:\Users\Sigurd\OneDrive - NTNU\elsys\semester5\ic\ic_project\verilog\camera_controller\src\camera_controller.v
// Generated   : Tue Nov  3 15:17:41 2020
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
//{module {camera_controller}}
module camera_controller ( init ,exp_increase ,exp_decrease ,clk ,rst ,NRE_1 ,NRE_2 ,ADC ,expose ,erase );

//}} End of automatically maintained section

input wire init ;
input wire exp_increase ;
input wire exp_decrease ;
input wire clk ;
input wire rst ;
output reg NRE_1 ;
output reg NRE_2 ;
output reg ADC ;
output reg expose ;
output reg erase ;

reg [5:0] exp_time;
reg [5:0] cnt;
reg [1:0] state;

// -- Enter your statements here -- //

initial begin
    NRE_1 = 1;
    NRE_2 = 1;
    ADC = 0;
    expose = 0;
    erase = 1;

    exp_time = 5'd16;
    cnt = 5'd0;
    state = 2'd0;
end

always @(posedge clk) begin
    if (rst) begin
        state = 2'd0;
    end else begin
        if (state == 2'd0) begin
            if (init) begin
                state = 2'd1;
                cnt = exp_time;
            end else begin
                if (exp_increase) begin
                    exp_time++;
                end else begin
                    if (exp_decrease) begin
                        exp_time--;
                    end
                end
            end
        end
        if (state == 2'd1) begin
            cnt--;
        end
    end
end

endmodule
