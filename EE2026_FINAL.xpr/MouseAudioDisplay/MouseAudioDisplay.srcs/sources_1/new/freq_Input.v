`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2023 10:51:55 PM
// Design Name: 
// Module Name: freq_Input
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module freq_Input(
    input clock, [11:0] sample, [11:0] peak_val,
    output reg [15:0] frequency_val 
    );
    
    //The output frequency frequency_val is between 100-17kHz
    reg [31:0] sample_count;
    reg[15:0] crosses;
    reg[15:0] last_frequency;
    reg up; // This is used to determine it is crossing from top
            //to bottom or vice versa
    initial begin
        up = 1;
    end
    
    always @ (posedge clock) begin
    // Clock to use: 50kHz
    // sample count = 250
    // Period = (1/50000)*250 = 0.005s
        sample_count = (sample_count == 250) ? 0: sample_count + 1;
        
        if (peak_val > 2300) begin
            if (sample >= peak_val/2 && up == 1) begin
                crosses <= (crosses == 16'b1111_1111_1111_1111) ? crosses : crosses + 1;
                up <= 0;
            end
            else if (sample <= peak_val/2 && up == 0) begin
                crosses <= (crosses == 16'b1111_1111_1111_1111)? crosses : crosses + 1;
                up <= 1;
            end
        end
        //now reset the counter and update frequency_val
        if (sample_count == 0) begin
            last_frequency <= crosses*200/2; // since period is 0.005s
            crosses <= 0;
        end
        frequency_val <= last_frequency;
    end
    
endmodule