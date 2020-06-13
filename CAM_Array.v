`timescale 1ns / 1ps

module CAM_Array #(parameter CAM_WIDTH = 8,CAM_DEPTH = 8,CAM_TYPE="BCAM") (
    input wire clk,
    input wire rst,
    input wire[CAM_DEPTH-1:0] we_decoded_row_address,
    input wire[CAM_WIDTH-1:0] search_word,
    input wire[CAM_WIDTH-1:0] dont_care_mask,
    output wire[CAM_DEPTH-1:0] decoded_match_address
    );

// Insert your solution below here. 
genvar i;
for(i = 0; i < CAM_DEPTH; i = i +1) begin: camrow
    CAM_Row #(
        .CAM_WIDTH (CAM_WIDTH), 
        .CAM_TYPE (CAM_TYPE))
        u_CAM_Row (
            .clk (clk),
            .rst (rst),
            .we (we_decoded_row_address[i]),
            .search_word (search_word),
            .dont_care_mask (dont_care_mask),
            .row_match (decoded_match_address[i])
        );
end

endmodule
