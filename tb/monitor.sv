import shared_pkg::*;
import fifo_transaction_pkg::*;
import fifo_coverage_pkg::*;
import fifo_scoreboard_pkg::*;
module monitor(fifo_if.MON f_if);
    fifo_transaction f_txn;
    fifo_coverage    f_cov;
    fifo_scoreboard  f_scb;

    initial begin
    f_txn = new;
    f_cov = new;
    f_scb = new;
    forever begin
        @start_sampling;
        // inputs
        f_txn.data_in = f_if.data_in;
        f_txn.rst_n   = f_if.rst_n;
        f_txn.wr_en   = f_if.wr_en;
        f_txn.rd_en   = f_if.rd_en;

        // outputs
        f_txn.data_out    = f_if.data_out;
        f_txn.wr_ack      = f_if.wr_ack;
        f_txn.overflow    = f_if.overflow;
        f_txn.full        = f_if.full;
        f_txn.empty       = f_if.empty;
        f_txn.almostfull  = f_if.almostfull;
        f_txn.almostempty = f_if.almostempty;
        f_txn.underflow   = f_if.underflow;

        fork
            begin
                f_cov.sample_data(f_txn);
            end
            begin
                f_scb.check_data(f_txn);
            end
        join

        if (test_finished) begin
            $display("Correct: %6d, Error: %6d", correct_count, error_count);
            $stop;
        end
    end
    end
endmodule
