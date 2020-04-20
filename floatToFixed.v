`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
module floatToFixed(
  input wire clk, 
  input wire rst , 
  input wire[31:0] float, 
  input wire[4:0] fixpointpos , 
  output wire[31:0] result );

wire [31:0] fixedresult ; 

// Your  Implementation 


// -------------------------------------------	
// Register the results 
// -------------------------------------------

always @ ( posedge clk ) begin 
    result <= fixedresult ;
end 
endmodule
