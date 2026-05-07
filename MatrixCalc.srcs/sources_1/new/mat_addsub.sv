`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: petproject
// Engineer: j4zzb4ss
// 
// Create Date: 07.05.2026 13:01:34
// Design Name: 
// Module Name: mat_addsub
// Project Name: matrixCalc
// Target Devices: 
// Tool Versions: 
// Description: модуль для проведения операций сложения или вычитания над двумя матрицами.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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

    // Промежуточные сигналы
    logic signed [DATA_W : 0] mat_extendet [N][N];
    logic                     cell_overflow [N][N];

    // Генерируем параллельные вычислители
    genvar r, c;
    generate
        for (r = 0; r < N; r++) begin : gen_row
            for (c = 0; c < N; c++) begin : gen_col
                
                // Вычисляем результат (17 бит для 16-битных входных данных)
                assign mat_extendet[r][c] = sub ? (mat_a[r][c] - mat_b[r][c]) 
                                                : (mat_a[r][c] + mat_b[r][c]);

                // Обрезаем до DATA_W бит для выхода
                assign mat_c[r][c] = mat_extendet[r][c][DATA_W-1:0];

                // Проверка переполнения для signed: 
                // если 17-й бит (знак расширенного) не равен 16-му биту (знак результата)
                assign cell_overflow[r][c] = (mat_extendet[r][c][DATA_W] != mat_extendet[r][c][DATA_W-1]);
            end
        end
    endgenerate

    // OR-дерево для флага overflow
    always_comb begin : overflowLogic
        logic any_ovf; // Локальная переменная
        any_ovf = 1'b0;
        for (int i = 0; i < N; i++) begin
            for (int j = 0; j < N; j++) begin
                any_ovf = any_ovf | cell_overflow[i][j];
            end
        end
        overflow = any_ovf;
    end

endmodule