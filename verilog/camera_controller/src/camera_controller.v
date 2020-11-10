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

reg [4:0] exp_time;
reg [4:0] cnt;
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
        // Reset: Go to idle state
        NRE_1 = 1;
        NRE_2 = 1;
        ADC = 0;
        expose = 0;
        erase = 1;

        exp_time = 5'd16;
        cnt = 5'd0;
        state = 2'd0;
    end else begin
        case (state)
            2'd0: begin
                // State is idle
                if (init) begin
                    // Go to exposure state
                    erase = 0;
                    expose = 1;
                    cnt = exp_time - 1;
                    state = 2'd1;
                end else begin
                    if (exp_increase) begin
                        if (exp_time < 30) exp_time++;
                    end else if (exp_decrease) begin
                        if (exp_time > 2) exp_time--;
                    end
                end
            end
            2'd1: begin
                // State is exposure
                if (cnt > 0) begin
                    cnt--;
                end else begin
                    // Go to readout state
                    expose = 0;
                    cnt = 5'd8;
                    state = 2'd2;
                end
            end
            2'd2: begin
                // State is readout
                if (cnt > 0) begin
                    case (cnt)
                        5'd8: NRE_1 = 0;
                        5'd7: ADC = 1;
                        5'd6: ADC = 0;
                        5'd5: NRE_1 = 1;
                        5'd4: NRE_2 = 0;
                        5'd3: ADC = 1;
                        5'd2: ADC = 0;
                        5'd1: NRE_2 = 1;
                    endcase
                    cnt--;
                end else begin
                    // Go to idle state
                    erase = 1;
                    state = 2'd0;
                end
            end
        endcase
    end
end

endmodule
