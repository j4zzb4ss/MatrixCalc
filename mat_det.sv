module mat_addsub #(
    parameter N      = 4,
    parameter DATA_W = 16
) (
    input  logic signed [DATA_W-1:0] mat_a [N][N],
    output logic                     det
);

    // TODO: формула для вычисления определителя

endmodule