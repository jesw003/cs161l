`timescale 1ns / 1ps

`define CAM_DEPTH 8
`define CAM_WIDTH 8

module CAM_Wrapper_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [`CAM_DEPTH-1:0] we_decoded_row_address;
    reg [`CAM_WIDTH-1:0] search_word;
    reg [`CAM_WIDTH-1:0] dont_care_mask;

    // Outputs
    wire [`CAM_DEPTH-1:0] decoded_match_address_BCAM;
    wire [`CAM_DEPTH-1:0] decoded_match_address_TCAM;
    wire [`CAM_DEPTH-1:0] decoded_match_address_STCAM;

    // Instantiate the Unit Under Test (UUT)
    // Notice all three uut's (uut, uut2, uut3) share all inputs and only differ on their output
    // You can differ all inputs and outputs if desired, but "sufficient" testing can be done 
    // by just checking the outputs and keeping all stored data the same.
    CAM_Wrapper #(.CAM_DEPTH(`CAM_DEPTH),.CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("BCAM")) uut (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_BCAM)
    );
    CAM_Wrapper #(.CAM_DEPTH(`CAM_DEPTH),.CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("TCAM")) uut2 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_TCAM)
    );
    CAM_Wrapper #(.CAM_DEPTH(`CAM_DEPTH),.CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("STCAM")) uut3 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_STCAM)
    );

    // Clock block 
    initial begin 
        clk = 0; rst = 1; #10;
        clk = 1; rst = 1; #10;
        clk = 0; rst = 0; #10;
        clk = 1; rst = 0; #10;

        forever begin 
            clk = ~clk; #10;
        end 
    end
    integer totalTests = 0;
    integer testGroup = 0;
    integer testNumber = 0;
    integer passedTests = 0;
    initial begin
        @(negedge rst); // Wait for rst to be released
        @(posedge clk); // Wait for first clk high out of rst
        // *****************************************************
        // First, write the values (address one example shown)
        // *****************************************************
        //     addr|  search   | don't care (stored)
        //      1  | 0000 0001 | 0000 0000
        //      2  | ???? ???? | ???? ????
        //      3  | ???? ???? | ???? ????
        //      4  | ???? ???? | ???? ????
        //         |           |
        //      5  | ???? ???? | ???? ????
        //      6  | ???? ???? | ???? ????
        //      7  | ???? ???? | ???? ????
        //      8  | ???? ???? | ???? ????
        // -------------------------------------------------------
        we_decoded_row_address = 8'h01;
        search_word = 8'h01; 
        dont_care_mask = 8'h00; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)
        
        
        //Change the dont_care_mask to store "don't care" bits for STCAM
        we_decoded_row_address = 8'h02;
        search_word = 8'h03; 
        dont_care_mask = 8'h02; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)
        

        we_decoded_row_address  = 8'h00; // No longer writing to addresses
        search_word  = 8'h01; 
        dont_care_mask = 8'h00; 
        @(posedge clk); @(posedge clk); #1; 
        //*********************************************************
        // Test cases
        //*********************************************************

        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 0;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (0000 0001 => 0000 0001)...",
            testGroup,testNumber);
        if (decoded_match_address_BCAM === 8'h01) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end


        //*********************************************************
        // Test cases
        //*********************************************************
        testGroup = testGroup + 1;
        $display("Test Group %0d: STCAM tests...",testGroup);
        testNumber = 0;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (0000 0001 => 0000 0001)...",
            testGroup,testNumber);
        if (decoded_match_address_STCAM === 8'h03) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        // Change the dont_care_mask to test "don't care" input bits for TCAM
        search_word  = 8'h03; 
        dont_care_mask = 8'h02; 
        @(posedge clk); @(posedge clk); #1; 
        //*********************************************************
        // Test cases
        //*********************************************************
        testGroup = testGroup + 1;
        $display("Test Group %0d: TCAM tests...",testGroup);
        testNumber = 0;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (0000 0001 => 0000 0001)...",
            testGroup,testNumber);
        if (decoded_match_address_TCAM === 8'h03) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        // ****************************************************************
        // End testing 
        // ****************************************************************
        $display("-------------------------------------------------------------");
        $display("Testing complete\nPassed %0d / %0d tests.",passedTests,totalTests);
        $display("-------------------------------------------------------------");
    end
   
endmodule

