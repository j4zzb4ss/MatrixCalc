module mat_addsub #(
    parameter N      = 4,
    parameter DATA_W = 16
) (
    input  logic signed [DATA_W-1:0] mat_a [N][N],
    input  logic signed [DATA_W-1:0] mat_b [N][N],
    input  logic                     sub,
    output logic signed [DATA_W-1:0] mat_c [N][N],
    output logic                     overflow
);

    // TODO: промежуточные сигналы шириной DATA_W+1
    // TODO: generate-блок: вычислить sum[r][c]
    // TODO: assign mat_c[r][c] из младших бит sum
    // TODO: OR-дерево для флага overflow

endmodule