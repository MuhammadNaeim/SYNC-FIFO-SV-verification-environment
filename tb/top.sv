module top;
    bit clk;
    initial forever #1 clk = !clk;

    // instace
    fifo_if f_if (clk);
    FIFO    DUT  (f_if);
    tb      TB   (f_if);
    monitor MON  (f_if);

    ////////////////// reset assertions //////////////////
    `ifdef SIM
        always_comb begin
            if(!f_if.rst_n) begin
                data_out_ia: assert final(f_if.data_out == 0);
                wr_ack_ia  : assert final(f_if.wr_ack   == 0);
                overflow_ia: assert final(f_if.overflow == 0);
            end
        end
    `endif
endmodule
