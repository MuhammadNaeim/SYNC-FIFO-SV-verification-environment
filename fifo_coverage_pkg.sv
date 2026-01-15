package fifo_coverage_pkg;
import fifo_transaction_pkg::*;
class fifo_coverage;
    // handel
    fifo_transaction f_cvg_txn;

    ////////////////// covergroup //////////////////
    covergroup cov_gp;
        // coverpoints
        wr_en_cp      : coverpoint f_cvg_txn.wr_en      ;
        rd_en_cp      : coverpoint f_cvg_txn.rd_en      ;
        wr_ack_cp     : coverpoint f_cvg_txn.wr_ack     ;
        overflow_cp   : coverpoint f_cvg_txn.overflow   ;
        full_cp       : coverpoint f_cvg_txn.full       ;
        empty_cp      : coverpoint f_cvg_txn.empty      ;
        almostfull_cp : coverpoint f_cvg_txn.almostfull ;
        almostempty_cp: coverpoint f_cvg_txn.almostempty;
        underflow_cp  : coverpoint f_cvg_txn.underflow  ;
        
        // cross coverage
        wr_ack_cc     : cross wr_en_cp, rd_en_cp, wr_ack_cp {
            illegal_bins wr_0 = binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect {1};
        }
        overflow_cc   : cross wr_en_cp, rd_en_cp, overflow_cp {
            illegal_bins wr_0 = binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect {1};
        }
        full_cc       : cross wr_en_cp, rd_en_cp, full_cp {
            illegal_bins rd_1 = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1};
        }
        empty_cc      : cross wr_en_cp, rd_en_cp, empty_cp      ;
        almostfull_cc : cross wr_en_cp, rd_en_cp, almostfull_cp ;
        almostempty_cc: cross wr_en_cp, rd_en_cp, almostempty_cp;
        underflow_cc  : cross wr_en_cp, rd_en_cp, underflow_cp {
            illegal_bins rd_0 = binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect {1};
        }
    endgroup: cov_gp

    // sample data function
    function void sample_data(fifo_transaction f_txn);
        f_cvg_txn = f_txn;
        cov_gp.sample;
    endfunction

    // constructor function
    function new();
        cov_gp = new;
    endfunction
endclass
endpackage
