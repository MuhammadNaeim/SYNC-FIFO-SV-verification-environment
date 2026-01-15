package fifo_transaction_pkg;
import shared_pkg::*;
class fifo_transaction;
    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic rst_n, wr_en, rd_en;
         logic [FIFO_WIDTH-1:0] data_out;
         logic wr_ack, overflow;
         logic full, empty, almostfull, almostempty, underflow;
         int RD_EN_ON_DIST, WR_EN_ON_DIST;

    ////////////////// constraints //////////////////
    constraint reset_c {rst_n dist{0:=1, 1:=99};}
    constraint wr_en_c {wr_en dist{0:=(100-WR_EN_ON_DIST), 1:=WR_EN_ON_DIST};}
    constraint rd_en_c {rd_en dist{0:=(100-RD_EN_ON_DIST), 1:=RD_EN_ON_DIST};}

    // constructor
    function new(input int RD_EN_ON_DIST = 30, WR_EN_ON_DIST = 70);
        this.RD_EN_ON_DIST = RD_EN_ON_DIST;
        this.WR_EN_ON_DIST = WR_EN_ON_DIST;
    endfunction
endclass
endpackage
