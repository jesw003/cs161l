`timescale 1ns / 1ps

`define MANTISSA_INDEX 23 

module fixtofloat(
	input wire[31:0] fixInput, 
	input wire[4:0]  fixpointIndex , 
	output reg[31:0] floatnumber   );

reg  thesign ;  
reg [7:0] theexponent;  
reg[31:0] themantissa ; 

reg[31:0] mask ; 
reg[31:0] fixnumber ; 

integer leadingOneIndex ; 
integer k ; 

// ------------------------------------------------------------------
// We have to extract the sign, the exponent and the mantissa
// ------------------------------------------------------------------ 

always @(*)  begin

	// Finding the sign bit 
	
	fixnumber = fixInput ; 
	thesign = fixnumber[31] ; 
	
	// If the number is negative we need the positive version 
	
	if (thesign == 1'b1 ) begin 
		fixnumber = $unsigned(~fixInput) + $unsigned(8'h01) ; 
	end  	

	// ------------------------------------------
	// Finding the leading one 
	// ------------------------------------------ 
	
	k = 0 ;
	leadingOneIndex = 0; 
		
	while ( k < 32 ) begin 			
			if ( fixnumber[k] == 1'b1 ) begin 
				leadingOneIndex = k; 			
		   end 		
		k = k+ 1 ; 		
	end 
	//there are total three cases		
	if ( leadingOneIndex > fixpointIndex ) begin 
		
		mask = 32'hFFFFFFFF >>(32 - leadingOneIndex);
		// Show your work 		
		theexponent = leadingOneIndex - fixpointIndex -1;
		
		fixnumber =(fixnumber & mask);

		if(fixpointIndex < 23) begin
			themantissa = fixnumber << (23 - (leadingOneIndex));
		end else begin
			themantissa = fixnumber >>( leadingOneIndex - 23);
		end
				
	end 
	else begin 
		mask = 32'hFFFFFFFF >>(32- fixpointIndex);
		// Show your work 		
		theexponent = leadingOneIndex  - fixpointIndex -1;
		// Compute the exponent 

		// ----------------------------------------------------------------
		// Working with the mantissa 
		// ----------------------------------------------------------------
		fixnumber =(fixnumber & mask);
		themantissa = fixnumber << (23 - fixpointIndex);
	end 
	theexponent = theexponent + 127;

	
	// Set the mantissa 
	floatnumber = {thesign, theexponent, themantissa[ 0 +: `MANTISSA_INDEX ] } ; 
		
end 


endmodule

