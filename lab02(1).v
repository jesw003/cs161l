`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module lab02(
   input wire clk, 
   input wire rst , 
	input wire[31:0] targetnumber, 
	input wire[4:0]  fixpointpos , 
	input wire  	  opcode , 
	output reg [31:0] result   );

wire [31:0] floatresult ; 
wire [31:0] fixresult ; 
wire [31:0] tresult ; 

// -------------------------------------------
// From fix to float 
// -------------------------------------------

 fixtofloat fix2float (
	.fixInput(targetnumber), 
	.fixpointIndex(fixpointpos-1) , 
	.floatnumber (floatresult)  );

// -------------------------------------------	
// From float to fix  
// -------------------------------------------

floattofix float2fix (
	.floatnumber (targetnumber) , 
	.fixpointpos (fixpointpos) , 
	.fixresult (fixresult) ); 


assign tresult = opcode == 1 ?  fixresult : floatresult ; 

// -------------------------------------------	
// Seq. part 
// -------------------------------------------

always @( posedge clk )  begin

   if ( rst == 1'b1 ) begin
      result <= 'd0 ; 
   end 

   else begin
		result <= tresult ; 
   end 

end 

endmodule

