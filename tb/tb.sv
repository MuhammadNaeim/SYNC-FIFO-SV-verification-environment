import shared_pkg::*;
import fifo_transaction_pkg::*;
module tb(fifo_if.TEST f_if);
fifo_transaction f_txn;

initial begin
    f_txn = new;
    test_finished = 0;
    
    // reset
    assert_reset;

    repeat (10000) begin
    @(negedge f_if.clk);
    assert(f_txn.randomize());
    drive_signals();
    #2 -> start_sampling;
    end

    test_finished = 1;
end

task assert_reset;
    f_if.rst_n = 0;
    repeat(3) @(negedge f_if.clk);
    f_if.rst_n = 1;
endtask

task drive_signals();
    f_if.data_in = f_txn.data_in;
    f_if.rst_n   = f_txn.rst_n;
    f_if.wr_en   = f_txn.wr_en;
    f_if.rd_en   = f_txn.rd_en;
endtask

endmodule
