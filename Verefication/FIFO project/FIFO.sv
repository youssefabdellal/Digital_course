import SHARED_pkg::*;
module FIFO(FIFO_if.DUT FIFO_DUT); 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_DUT.clk or negedge FIFO_DUT.rst_n) begin
	if (!FIFO_DUT.rst_n) begin
		wr_ptr <= 0;
		FIFO_DUT.overflow <= 0;
	end
	else if ((({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b10) && (count < FIFO_DEPTH)) 
				|| (({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b11) && (count < FIFO_DEPTH))) begin
		mem[wr_ptr] <= FIFO_DUT.data_in;
		FIFO_DUT.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		FIFO_DUT.wr_ack <= 0; 
		if (FIFO_DUT.full && FIFO_DUT.wr_en)
			FIFO_DUT.overflow <= 1;
		else
			FIFO_DUT.overflow <= 0;
	end
end

always @(posedge FIFO_DUT.clk or negedge FIFO_DUT.rst_n) begin
	if (!FIFO_DUT.rst_n) begin
		rd_ptr <= 0;
		FIFO_DUT.underflow <= 0 ;
	end
	else if ((({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b01) && count != 0) 
				|| ( ({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b11) && count == FIFO_DEPTH) ) begin
		FIFO_DUT.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin
		if (FIFO_DUT.empty && FIFO_DUT.rd_en)
			FIFO_DUT.underflow <= 1;
		else
			FIFO_DUT.underflow <= 0;
	end
end

always @(posedge FIFO_DUT.clk or negedge FIFO_DUT.rst_n) begin
	if (!FIFO_DUT.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b10) && !FIFO_DUT.full) 
			count <= count + 1;
		else if ( ({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b01) && !FIFO_DUT.empty)
			count <= count - 1;
		else if ( ({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b11) && !FIFO_DUT.full)
			count <= count + 1;
		else if ( ({FIFO_DUT.wr_en , FIFO_DUT.rd_en} == 2'b11) && FIFO_DUT.full)
			count <= count - 1;
	end
end

assign FIFO_DUT.full = (count == FIFO_DEPTH)? 1 : 0;
assign FIFO_DUT.empty = (count == 0)? 1 : 0;
assign FIFO_DUT.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign FIFO_DUT.almostempty = (count == 1)? 1 : 0;


property reset_behave;
	@(posedge FIFO_DUT.clk) (!FIFO_DUT.rst_n) |-> (wr_ptr == 0 && rd_ptr == 0 && count == 0) ;
endproperty

property write_ACK;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && FIFO_DUT.wr_en && !FIFO_DUT.full) |=> (FIFO_DUT.wr_ack) ;
endproperty

property overflow_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && FIFO_DUT.wr_en && FIFO_DUT.full) |=> (FIFO_DUT.overflow) ;
endproperty

property underflow_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && FIFO_DUT.rd_en && FIFO_DUT.empty) |=> (FIFO_DUT.underflow) ;
endproperty

property emptyflag_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && count == 0 ) |-> (FIFO_DUT.empty ) ; 
endproperty

property fullflag_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && count == FIFO_DEPTH ) |-> (FIFO_DUT.full) ; 
endproperty

property almostfull_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && count == FIFO_DEPTH - 1  ) |-> (FIFO_DUT.almostfull) ; 
endproperty

property almostempty_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && count == 1  ) |-> (FIFO_DUT.almostempty) ; 
endproperty

property wrpointer_wrapground_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && wr_ptr == FIFO_DEPTH-1 && FIFO_DUT.wr_en && !FIFO_DUT.full ) |=> (wr_ptr == 0) ; 
endproperty

property rdpointer_wrapground_detection;
	@(posedge FIFO_DUT.clk) (FIFO_DUT.rst_n && rd_ptr == FIFO_DEPTH-1 && FIFO_DUT.rd_en && !FIFO_DUT.empty && FIFO_DUT.full ) |=> (rd_ptr == 0) ; 
endproperty

property counter_wrapground_detection;
	@(posedge FIFO_DUT.clk) (!FIFO_DUT.rst_n && count == FIFO_DEPTH ) |=> (count == 0) ; 
endproperty

property wrpointer_threshold;
  @(posedge FIFO_DUT.clk)
    FIFO_DUT.rst_n |-> (wr_ptr < FIFO_DEPTH);
endproperty

property rdpointer_threshold;
  @(posedge FIFO_DUT.clk)
    FIFO_DUT.rst_n |-> (rd_ptr < FIFO_DEPTH);
endproperty

property counter_threshold;
  @(posedge FIFO_DUT.clk)
    FIFO_DUT.rst_n |-> (count <= FIFO_DEPTH);
endproperty

`ifdef SIM
// Reset behavior
assert_reset_behave: assert property(reset_behave)
  else $error("Reset did not clear wr_ptr, rd_ptr, or count!");
cover_reset_behave: cover property(reset_behave);

// Write acknowledge
assert_write_ACK: assert property(write_ACK)
  else $error("Write acknowledge failed when wr_en && !full");
cover_write_ACK: cover property(write_ACK);

// Overflow detection
assert_overflow_detection: assert property(overflow_detection)
  else $error("Overflow not detected when write attempted on full FIFO!");
cover_overflow_detection: cover property(overflow_detection);

// Underflow detection
assert_underflow_detection: assert property(underflow_detection)
  else $error("Underflow not detected when read attempted on empty FIFO!");
cover_underflow_detection: cover property(underflow_detection);

// Empty flag
assert_emptyflag_detection: assert property(emptyflag_detection)
  else $error("Empty flag not asserted when count == 0!");
cover_emptyflag_detection: cover property(emptyflag_detection);

// Full flag
assert_fullflag_detection: assert property(fullflag_detection)
  else $error("Full flag not asserted when count == FIFO_DEPTH!");
cover_fullflag_detection: cover property(fullflag_detection);

// Almost full
assert_almostfull_detection: assert property(almostfull_detection)
  else $error("Almost full flag not asserted when count == FIFO_DEPTH-1!");
cover_almostfull_detection: cover property(almostfull_detection);

// Almost empty
assert_almostempty_detection: assert property(almostempty_detection)
  else $error("Almost empty flag not asserted when count == 1!");
cover_almostempty_detection: cover property(almostempty_detection);

// Write pointer wraparound
assert_wrpointer_wraparound: assert property(wrpointer_wrapground_detection)
  else $error("Write pointer did not wrap around to 0!");
cover_wrpointer_wraparound: cover property(wrpointer_wrapground_detection);

// Read pointer wraparound
assert_rdpointer_wraparound: assert property(rdpointer_wrapground_detection)
  else $error("Read pointer did not wrap around to 0!");
cover_rdpointer_wraparound: cover property(rdpointer_wrapground_detection);

assert_counter_reset: assert property (counter_wrapground_detection)
  else $error("Counter did not reset to 0!");
cover_counter_reset: cover property (counter_wrapground_detection);

assert_wrpointer_threshold: assert property (wrpointer_threshold)
  else $error("Write pointer exceeded FIFO_DEPTH-1!");
cover_wrpointer_threshold: cover property (wrpointer_threshold);

assert_rdpointer_threshold: assert property (rdpointer_threshold)
  else $error("Read pointer exceeded FIFO_DEPTH-1!");
cover_rdpointer_threshold: cover property (rdpointer_threshold);

assert_counter_threshold: assert property (counter_threshold)
  else $error("Counter exceeded FIFO_DEPTH!");
cover_counter_threshold: cover property (counter_threshold);

`endif

endmodule