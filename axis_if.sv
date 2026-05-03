interface axis_if #(parameter DATA_W = 16);
    logic signed [DATA_W-1:0] s_axis_tdata;
    logic                     s_axis_tvalid;
    logic                     s_axis_tlast;
    logic                     s_axis_tready;
    logic                     recv_done;
    logic                     flash;

    // Определяем два направления (роли)
    modport master (
        output s_axis_tdata,
        output s_axis_tvalid,
        output s_axis_tlast,
        input  s_axis_tready
    );

    modport slave (
        input  s_axis_tdata,
        input  s_axis_tvalid,
        input  s_axis_tlast,
        output s_axis_tready
    );
endinterface