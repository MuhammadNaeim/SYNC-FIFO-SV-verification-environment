////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design
//
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
module FIFO(fifo_if.DUT f_if);

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		wr_ptr        <= 0;
		f_if.wr_ack   <= 0; //////////// wr_ack reset
		f_if.overflow <= 0; //////////// overflow reset
		for (int i = 0; i < FIFO_DEPTH; i++)
			mem[i] <= 0; //////////// memory reset
	end
	else if (f_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= f_if.data_in;
		f_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin
		f_if.wr_ack <= 0;
		if (f_if.full && f_if.wr_en) ////logical operator "&&"
			f_if.overflow <= 1;
		else
			f_if.overflow <= 0;
	end
end

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		f_if.data_out <= 0; ///////// reset data_out
		rd_ptr <= 0;
	end
	else if (f_if.rd_en && count != 0) begin
		f_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		count <= 0;
	end
	else begin
		////////// both enabled condition
		if (({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.empty)
			count <= count + 1;
		else if (({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.full)
			count <= count - 1;
		else if (({f_if.wr_en, f_if.rd_en} == 2'b10) && !f_if.full)
			count <= count + 1;
		else if (({f_if.wr_en, f_if.rd_en} == 2'b01) && !f_if.empty)
			count <= count - 1;
		else
			count <= count;
	end
end

assign f_if.full        = (count == FIFO_DEPTH)? 	  1 : 0;
assign f_if.empty       = (count == 0)? 			  1 : 0;
assign f_if.underflow   = (count == 0 && f_if.rd_en)? 1 : 0;
assign f_if.almostfull  = (count == FIFO_DEPTH-1)?    1 : 0; //// -1
assign f_if.almostempty = (count == 1)?               1 : 0;



////////////////// assertions //////////////////
`ifdef SIM
	// reset_ia
	always_comb begin
		if(!f_if.rst_n) begin
			rd_ptr_ia: assert final(rd_ptr == 0);
			wr_ptr_ia: assert final(wr_ptr == 0);
			count_a  : assert final(count  == 0);
		end
	end
	property wr_ack_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.wr_en && !f_if.full) |=> f_if.wr_ack;
	endproperty
	property overflow_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.wr_en && f_if.full) |=> f_if.overflow;
	endproperty
	property underflow_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.rd_en && f_if.empty) |-> f_if.underflow;
	endproperty
	property empty_p;
		@(posedge f_if.clk) (count == 0) |-> f_if.empty;
	endproperty
	property full_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) (count == FIFO_DEPTH) |-> f_if.full;
	endproperty
	property almostfull_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) (count == FIFO_DEPTH-1) |-> f_if.almostfull;
	endproperty
	property almostempty_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) (count == 1) |-> f_if.almostempty;
	endproperty
	property wr_ptr_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) wr_ptr == FIFO_DEPTH-1 |-> wr_ptr == 0 [->1];
	endproperty
	property rd_ptr_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) rd_ptr == FIFO_DEPTH-1 |-> wr_ptr == 0 [->1];
	endproperty
	property ptr_p;
		@(posedge f_if.clk) disable iff (!f_if.rst_n) wr_ptr != FIFO_DEPTH |rd_ptr != FIFO_DEPTH;
	endproperty
	// b
	wr_ack_a: assert property (wr_ack_p);
	wr_ack_c: cover  property (wr_ack_p);
	// c
	overflow_a: assert property (overflow_p);
	overflow_c: cover  property (overflow_p);
	// d
	underflow_a: assert property (underflow_p);
	underflow_c: cover  property (underflow_p);
	// e
	empty_a: assert property (empty_p);
	empty_c: cover  property (empty_p);

	// f
	full_a: assert property (full_p);
	full_c: cover  property (full_p);

	// g
	almostfull_a: assert property (almostfull_p);
	almostfull_c: cover  property (almostfull_p);

	// h
	almostempty_a: assert property (almostempty_p);
	almostempty_c: cover  property (almostempty_p);

	// i
	wr_ptr_a: assert property (wr_ptr_p);
	wr_ptr_c: cover  property (wr_ptr_p);

	// i
	rd_ptr_a: assert property (rd_ptr_p);
	rd_ptr_c: cover  property (rd_ptr_p);

	// j
	ptr_a: assert property (ptr_p) else $error("ptrs are off limits");
	ptr_c: cover  property (ptr_p);

`endif

endmodule
// bugs:
// output signals and registers are not in reset
// almost full condition is wrong

