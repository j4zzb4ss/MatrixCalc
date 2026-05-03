module mat_transpose #(
    parameter N      = 4,
    parameter DATA_W = 16
) (
    input  logic signed [DATA_W-1:0] mat_a [N][N],
    output logic signed [DATA_W-1:0] mat_c [N][N]
);

    // TODO: generate-блок с assign mat_c[r][c] = mat_a[???][???]

endmodule