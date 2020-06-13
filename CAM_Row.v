`timescale 1ns / 1ps

module CAM_Row #(parameter CAM_WIDTH = 8,CAM_TYPE="BCAM") (
    input wire clk,
    input wire rst,
    input wire we,
    input wire[CAM_WIDTH-1:0] search_word,
    input wire[CAM_WIDTH-1:0] dont_care_mask,
    output wire row_match
    );

// Insert your solution below here. (Default to BCAM if CAM_TYPE is unknown)
genvar i;
wire [CAM_WIDTH : 0] cell_match_bit;

assign cell_match_bit[0] = 1'b1;
assign row_match = cell_match_bit[CAM_WIDTH];

if(CAM_TYPE == "STCAM") begin: u1
    for(i = 0; i < CAM_WIDTH; i = i + 1) begin: cambit
        STCAM_Cell u_STCAM_CELL (
            .clk (clk),
            .rst (rst),
            .we (we),
            .cell_search_bit (search_word[i]),
            .cell_dont_care_bit (dont_care_mask[i]),
            .cell_match_bit_in (cell_match_bit[i]),
            .cell_match_bit_out (cell_match_bit[i + 1])
        );
    end
end
else if(CAM_TYPE == "TCAM") begin: u2
    for(i = 0; i < CAM_WIDTH; i = i + 1) begin: cambit
        TCAM_Cell u_TCAM_CELL (
            .clk (clk),
            .rst (rst),
            .we (we),
            .cell_search_bit (search_word[i]),
            .cell_dont_care_bit (dont_care_mask[i]),
            .cell_match_bit_in (cell_match_bit[i]),
            .cell_match_bit_out (cell_match_bit[i + 1])
        );
    end
end
else begin: u3
    for(i = 0; i < CAM_WIDTH; i = i + 1) begin: cambit
        BCAM_Cell u_BCAM_CELL (
            .clk (clk),
            .rst (rst),
            .we (we),
            .cell_search_bit (search_word[i]),
            .cell_dont_care_bit (dont_care_mask[i]),
            .cell_match_bit_in (cell_match_bit[i]),
            .cell_match_bit_out (cell_match_bit[i + 1])
        );
    end
end

endmodule
