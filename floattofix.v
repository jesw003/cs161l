`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module floattofix(
	input wire[31:0] floatnumber, 
	input wire[4:0]  fixpointpos , 
	output reg[31:0] fixresult   );

reg [7:0]  theexponent;
  
reg [31:0] mantissa ; 
reg [31:0] integerpart ; 
reg [31:0] fractionalpart ; 


// ------------------------------------------------------------------
// We have to extract the sign, the exponent and the mantissa
// ------------------------------------------------------------------ 

always @(*)  begin

	mantissa =  { 8'h00, 1'b1, floatnumber[22:0]  } ; 
	fixresult = mantissa;
	// If the exponent is positive ( 127 + exponent )
	theexponent = $unsigned(floatnumber[23 +: 8 ]);
	if ( $unsigned(floatnumber[23 +: 8 ]) >= $unsigned(8'h7f)) begin 
		theexponent = theexponent - 127;
		fractionalpart = 22- theexponent;
		if(fixpointpos > 23 ) begin
			fixresult = fixresult <<((fixpointpos-1)-fractionalpart);
		end else begin
			fixresult = fixresult >>(fractionalpart -(fixpointpos-1));
		end

	end
	
	else begin   
		theexponent = 127 - theexponent;
		fractionalpart = 22 + theexponent;
		if(fixpointpos > 23 ) begin
			fixresult = fixresult <<((fixpointpos-1)-fractionalpart);
		end else begin
			fixresult = fixresult >>(fractionalpart -(fixpointpos-1));
		end

	end 
	
	// ------------------------------------------------------------------------
	// In the input number is negative, we have to compute the two's complement 
	// ------------------------------------------------------------------------
	
	if (floatnumber[31] == 1  ) begin 
		fixresult = $unsigned(~fixresult) + $unsigned(32'h0000_0001) ; 	
	end 
	
end 


endmodule
