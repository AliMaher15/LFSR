`timescale 1ns/1ns

module LFSR_TB ();

////////////////////////////////////////////////////////
////////////          TB Signals           /////////////
////////////////////////////////////////////////////////
reg              clk_TB;
reg              rst_TB;
reg    [3:0]     Seed_TB;
wire             OUT_TB;
wire             Valid_TB;

////////////////////////////////////////////////////////
////////////         TB Parameters         /////////////
////////////////////////////////////////////////////////
parameter    clk_period = 100 ;

////////////////////////////////////////////////////////
////////////       Clock Generator         /////////////
////////////////////////////////////////////////////////
always #(clk_period/2)  clk_TB = !clk_TB ;

////////////////////////////////////////////////////////
/////////////     DUT Instantiation        /////////////
////////////////////////////////////////////////////////
LFSR DUT (
.clk(clk_TB),
.rst(rst_TB),
.Seed(Seed_TB),
.OUT(OUT_TB),
.Valid(Valid_TB)
);

////////////////////////////////////////////////////////
////////////            INITIAL             ////////////
////////////////////////////////////////////////////////
initial
 begin
$dumpfile("LFSR.vcd");
$dumpvars;
      
//initialization
initialize() ;

//Reset the design
reset();

// LFSR Mode
$display("**** TEST CASE 1 ****");
$display("LFSR Mode");
Count_cycles(4'b100) ;  // input is number of cycles

Check_Valid(1'b0) ;

Count_cycles(4'b101) ;  // 8 cycles have passed

// Shift Mode
$display("**** TEST CASE 2 ****");
$display("Shift Mode and check if OUT is Valid");

repeat(4)
 begin
  Check_Valid(1'b1) ;
  Count_cycles(4'b1) ;
 end

// All Registers are shifted to OUT
$display("**** TEST CASE 3 ****");
$display("All 4 Registers are extracted");
Check_Valid(1'b0) ;
   

#100

$stop ;

end


////////////////////////////////////////////////////////
/////////////            TASKS             /////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
 begin
  clk_TB = 1'b0  ; 
  Seed_TB = 4'b1001 ;
 end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
  rst_TB = 1'b1  ;  // deactivated
  #(clk_period/2)
  rst_TB = 1'b0  ;  // activated
  #(clk_period/2)
  rst_TB = 1'b1  ;  // decativated
 end
endtask

/////////////// Count Cycles  /////////////////

task Count_cycles ;
 input [3:0] cycles ;
 
 begin
  if(cycles != 4'b1)
    $display("Wait %d Cycles", cycles) ;
  else
    $display("Wait %d Cycle", cycles) ;
  #(clk_period*cycles) ;
 end
endtask

///////////// Check Valid bit  ////////////////

task Check_Valid ;
 input   data ;
 
 begin
  $display(">> Valid flag = %d", Valid_TB) ;
  if(Valid_TB != data)
    $display("FAILED");
  else
   if(data == 1'b1)
     $display(">> OUT = %d", OUT_TB);
   else
     $display("SUCCESS");
 end
endtask

endmodule