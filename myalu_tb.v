`timescale 1ns / 1ps

module myalu_tb;
	parameter NUMBITS = 8;

	// Inputs
	reg clk;
	reg reset; 
	reg [NUMBITS-1:0] A;
	reg [NUMBITS-1:0] B;
	reg [2:0] opcode;

	// Outputs
	wire [NUMBITS-1:0] result;
	reg [NUMBITS-1:0] R;
	wire carryout;
	wire overflow;
	wire zero;

    // -------------------------------------------------------
	// Instantiate the Unit Under Test (UUT)
	// -------------------------------------------------------
	myalu #(.NUMBITS(NUMBITS)) uut (
        .clk(clk),
		.reset(reset) ,  
		.A(A), 
		.B(B), 
		.opcode(opcode), 
		.result(result), 
		.carryout(carryout), 
		.overflow(overflow), 
		.zero(zero)
	);

  	initial begin 
	
	 clk = 0; reset = 1; #50; 
	 clk = 1; reset = 1; #50; 
	 clk = 0; reset = 0; #50; 
	 clk = 1; reset = 0; #50; 
		 
	 forever begin 
		clk = ~clk; #50; 
	 end 
	 
	end 
	
    integer totalTests = 0;
    integer failedTests = 0;
	initial begin // Test suite
        // Reset
        @(negedge reset); // Wait for reset to be released (from another initial block)
        @(posedge clk); // Wait for first clock out of reset 
	    #10; // Wait 

        // Additional test cases
		// ---------------------------------------------
		// Testing unsigned additions 
		// --------------------------------------------- 
        $write("Test Group 1: Testing unsigned additions ... \n");
		opcode = 3'b000; 
        totalTests = totalTests + 1;
        $write("\tTest Case 1.1: Unsigned Add ... ");
		A = 8'hFF;
   	    B = 8'h01;
		R = 8'h00; 
        #100; // Wait 
		if (R != result || zero != 1'b1 || carryout != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait 
		
        totalTests = totalTests + 1;
		$write("\tTest Case 1.2 Unsigned Add ...");
		A = 8'h01;
        B = 8'h00;
		R = 8'h01; 
		#100;
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
	
        totalTests = totalTests + 1;
		$write("\tTest Case 1.3 Unsigned Add ...");
		A = 8'hff;
   		B = 8'h01;
		R = 8'h00; 
		#100;
		if (R != result || zero != 1'b1 || carryout != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 1.4 Unsigned Add ...");
		A = 8'h0f;
   		B = 8'hf0;
		R = 8'hff; 
		#100;
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 1.5 Unsigned Add ...");
		A = 8'h0f;
   		B = 8'h0f;
		R = 8'h1e; 
		#100;
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		// ---------------------------------------------
		// Testing unsigned subs 
		// --------------------------------------------- 
        $write("Test Group 2: Testing unsigned subs ...\n");

		opcode = 3'b010; 
        totalTests = totalTests + 1;
		$write("\tTest Case 2.1 Unsigned subs ...");
		A = 8'h00;
   		B = 8'h00;
		R = 8'h00; 
		#100;
		if (R != result || zero != 1'b1 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 2.2 Unsigned subs ...");
		A = 8'hff;
   		B = 8'hff;
		R = 8'h00; 
		#100;
		if (R != result || zero != 1'b1 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 2.3 Unsigned subs ...");
		A = 8'h1f;
   		B = 8'h0f;
		R = 8'h10; 
		#100;
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 2.4 Unsigned subs ...");
		A = 8'hff;
   		B = 8'h0f;
		R = 8'hf0; 
		#100;
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
				
        totalTests = totalTests + 1;
		$write("\tTest Case 2.5 Unsigned subs ...");
		A = 8'h0A;
   		B = 8'h01;
		R = 8'h09; 
		#100;
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		// ---------------------------------------------
		// Testing signed adds 
		// --------------------------------------------- 
        $write("Test Group 3: Testing signed adds ...\n");
		opcode = 3'b001; 

        totalTests = totalTests + 1;
		$write("\tTest Case 3.1 Signed adds ...");
		A = 8'h0A;
   		B = 8'h01;
		R = 8'h0B; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		
        totalTests = totalTests + 1;
		$write("\tTest Case 3.2 Signed adds ...");
		A = 8'hAE;
   		B = 8'h01;
		R = 8'hAF; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		
        totalTests = totalTests + 1;
		$write("\tTest Case 3.3 Signed adds ...");
		A = 8'hAE;
   		B = $signed(~({8'hAE})) + $signed(2'b01);
		R = 8'h00; 
		#100;
		if (R != result || zero != 1'b1 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 3.4 Signed adds ...");
		A = $signed(~({8'h08})) + $signed(2'b01);
   		B = $signed(~({8'h07})) + $signed(2'b01);
		R = $signed(~({8'h0f})) + $signed(2'b01);
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 3.5 Signed adds ...");
		A = $signed(~({8'h08})) + $signed(2'b01);
   		B = $signed(({8'h07}));
		R = $signed(~({8'h01})) + $signed(2'b01);
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		// ---------------------------------------------
		// Testing signed subs 
		// --------------------------------------------- 
        $write("Test Group 4: Testing signed subs ...\n");
		opcode = 3'b011; 
		
        totalTests = totalTests + 1;
		$write("\tTest Case 4.1 Signed adds ...");
		A = $signed({8'h08}); // +8 
		B = $signed(~({8'h08})) + $signed(2'b01); // -8 
		R = 8'h10;  // 8 -(-8) = h10
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 4.2 Signed adds ...");
		A = $signed({8'h08}); // +8 
		B = $signed({8'h08}); // +8   
		R = 8'h00;  // 8 (-8) = h00
		#100;
		if (R != result || zero != 1'b1 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 4.3 Signed adds ...");
		A = $signed({8'h08}); // +8 
		B = $signed({8'h01}); // +1   
		R = 8'h07;  // 8 -(+1) = h07
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
				
        totalTests = totalTests + 1;
		$write("\tTest Case 4.5 Signed adds ...");
		A = $signed(~({8'h40})) + $signed(8'h01); // -64
		B = $signed({8'h40}); // +64
		R = $signed({8'h80}); // -64 - (+64) = -128 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 4.5 Signed adds ...");
		A = $signed(~({8'h40})) + $signed(8'h01); // -64
		B = $signed({8'h41}); // +65
		R = $signed({8'h7f}); // -64 - (+65) = -129
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		// ---------------------------------------------
		// Testing ANDS 
		// --------------------------------------------- 
        $write("Test Group 5: Testing ANDs ...\n");
		opcode = 3'b100; 
		
        totalTests = totalTests + 1;
		$write("\tTest Case 5.1 ANDs ...");
		A = 8'hff; 
		B = 8'h00; 
		R = 8'h00; 
		#100;
		if (R != result || zero != 1'b1 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 5.2 ANDs ...");
		A = 8'hff; 
		B = 8'h0f; 
		R = 8'h0f; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		// ----------------------------------------
		// ORs 
		// ---------------------------------------- 
        $write("Test Group 6: Testing ORs ...\n");
		opcode = 3'b101; 
		
        totalTests = totalTests + 1;
		$write("\tTest Case 6.1 ORs ...");
		A = 8'hff; 
		B = 8'h00; 
		R = 8'hff; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 6.2 ORs ...");
		A = 8'h0f; 
		B = 8'h1f; 
		R = 8'h1f; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		// ----------------------------------------
		// XORs 
		// ---------------------------------------- 
        $write("Test Group 6: Testing XORs ...\n");
		opcode = 3'b110; 
		
        totalTests = totalTests + 1;
		$write("\tTest Case 7.1 XORs ...");
		A = 8'h0f; 
		B = 8'hf0; 
		R = 8'hff; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 7.2 XORs ...");
		A = 8'hff; 
		B = 8'hff; 
		R = 8'h00; 
		#100;
		if (R != result || zero != 1'b1 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
		// ----------------------------------------
		// Div 2 
		// ----------------------------------------
        $write("Test Group 8: Testing DIV 2 ...\n");
		opcode = 3'b111; 
		
        totalTests = totalTests + 1;
		$write("\tTest Case 8.1 Divs ...");
		A = 8'h10; 
		R = 8'h08; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		
        totalTests = totalTests + 1;
		$write("\tTest Case 8.2 Divs ...");
		A = 8'hFF; 
		R = 8'h7F; 
		#100;
		if (R != result || zero != 1'b0 || overflow != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        // -------------------------------------------------------
        // End testing
        // -------------------------------------------------------
        $write("\n-------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests", totalTests-failedTests,totalTests);
        $write("\n-------------------------------------------------------");
	end
endmodule


