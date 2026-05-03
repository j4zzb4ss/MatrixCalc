module apb_csr #(
    parameter DATA_W = 16
) (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [7:0]  paddr,
    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,
    output logic        pslverr,
    // Выходы к основной логике
    output logic [1:0]  op,
    output logic        start,
    // Входы статуса (для REG_STATUS)
    input  logic        done_i,
    input  logic        busy_i,
    input  logic        overflow_i,
    input  logic        singular_i
);

    // TODO: объявить регистры для OP, START
    // TODO: логика записи (фаза ACCESS)
    // TODO: логика чтения (комбинационно)
    // TODO: самосброс START

endmodule