`timescale 1ns / 1ps

module fixedFloatConversion_tb;
    // Inputs
    reg clk; 
    reg rst; 
    reg [31:0] targetnumber;
    reg [4:0] fixpointpos;
    reg  opcode; 
    
    wire [31:0] resultnumber;
    reg [31:0] R;
    
    // ---------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // --------------------------------------------------- 
    fixedFloatConversion uut (
        .clk( clk ) , 
        .rst(rst) ,         
        .targetnumber(targetnumber), 
        .fixpointpos(fixpointpos),
        .opcode(opcode) , 
        .result(resultnumber)
    );

    initial begin 
        clk = 0; rst = 1; #50; 
        clk = 1; rst = 1; #50; 
        clk = 0; rst = 0; #50; 
        clk = 1; rst = 0; #50; 
        forever begin 
            clk = ~clk; #50; 
        end 
    end
     
    integer failedTests = 0;
    integer totalTests = 0;
    initial begin
        // Reset
        @(negedge reset); // Wait for reset to be released (from another initial block)
        @(posedge clk); // Wait for first clock out of reset 
        #10; // Wait 

        fixpointpos = 4'b0000;
        targetnumber = { 32'h0 }; 
        R = { 32'h0 }; 
        // -------------------------------------------------------
        // Test group 1: Floating point to fixed point
        // -------------------------------------------------------
        $display("Test Group 1: Testing Floating point to fixed point... ");
        opcode = 1'b0; 

        $write("\tTest Case 1.1: Convert 25.25 (011001.01,2=>0 010000011 1001010..)...");
        totalTests = totalTests + 1;
        // Set inputs
        fixpointpos = 4'b0010;
        targetnumber = { {24'h000000}, {8'b011001_01}  }; 
        R = 32'b0_10000011_10010100000000000000000;
        #100; // Wait
        if (R != resultnumber) begin
            $display("failed"); 
            failedTests = failedTests + 1;
        end else begin
            $display("passed"); 
        end
            
        // -------------------------------------------------------
        // Test group 2: Fixed point to floating point
        // -------------------------------------------------------
        $display("Test Group 2: Testing Fixed point to floating point... ");
        opcode = 1'b1; 

        $write(" Test Case 2.1: 25.25 (0 10000011 1001010,2=>011001.01)..."); 
        totalTests = totalTests + 1;
        opcode = 1'b1; 
        fixpointpos = 4'b0010;
        targetnumber = 32'b0_10000011_10010100000000000000000;
        R = { {24'h000000}, {8'b011001_01}  };  
        #100; 
        if ( R != resultnumber) begin
            $display("failed");
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end
            

        // --------------------------------------------------------------
        // End testing
        // --------------------------------------------------------------
        $write("\n--------------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests",totalTests-failedTests,totalTests);
        $write("\n--------------------------------------------------------------");
    end
endmodule

