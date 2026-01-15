package fifo_scoreboard_pkg;
import shared_pkg::*;
import fifo_transaction_pkg::*;
class fifo_scoreboard;
    logic [FIFO_WIDTH-1:0] data_out_ref = 0;
    logic full_ref = 0, empty_ref = 1;
    bit [FIFO_WIDTH-1:0] fifo_q [$];

    // check data
    function void check_data(fifo_transaction f_txn);
        reference_model(f_txn);
        if (data_out_ref === f_txn.data_out)
            correct_count++;
        else begin
            error_count++;
            $display("ERROR: data_out = %h, expected: %h",f_txn.data_out ,data_out_ref);
        end
    endfunction

    // ref model
    function void reference_model(fifo_transaction f_txn);
        if (!f_txn.rst_n) begin
            data_out_ref = 0;
            full_ref     = 0;
            empty_ref    = 1;
            fifo_q.delete();
        end
        else begin
            if (f_txn.wr_en && !full_ref)
                fifo_q.push_back(f_txn.data_in);

            if (f_txn.rd_en && !empty_ref)
                data_out_ref = fifo_q.pop_front();
                
            empty_ref = fifo_q.size() == 0;
            full_ref  = fifo_q.size() == FIFO_DEPTH;
        end
    endfunction
endclass
endpackage
