module LFSR (
  input   wire          clk,
  input   wire          rst,
  input   wire  [3:0]   Seed,
  output  reg           OUT,
  output  reg           Valid
  );
  
  // Inner Signals
  reg      [3:0]   R ;
  wire             feedback ;
  reg      [3:0]   counter ;
  reg             Shift_mode_only ;
  integer          I ;
  
  //inner Registers and Valid flag behaviour
  always @(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          Valid <= 1'b0 ;
          for(I = 0 ; I < 4 ; I = I + 1)
            begin
              R[I] <= Seed[I] ;
            end
        end
      else
        begin
          if(!Shift_mode_only)
            begin
              Valid <= 1'b0 ;
              R[3] <= feedback ;
              for(I = 2 ; I > -1 ; I = I - 1)
                begin
                  R[I] <= R[I+1] ;
                end
            end
          else
            begin
              R <= R >> 1 ;
              Valid <= 1'b1 ;
            end
        end
    end
    
    
  // OUT behaviour
  always @(posedge clk)
    begin
      OUT <= R[0] ;
    end
    
  // Counter behaviour
  always @(posedge clk or negedge rst)
    begin
      if(!rst)
        counter <= 4'b0 ;
      else
        counter <= counter + 4'b1 ;
    end
  
  // Flag to switch from LFSR mode to shift mode
  always @(*)
    begin
      if((counter >= 4'b1000) && (counter <= 4'b1011))
        Shift_mode_only = 1'b1 ;
      else
        Shift_mode_only = 1'b0 ;
    end
  
  
  assign feedback = R[2] ^ (R[1] ^ R[0]) ;
  
endmodule