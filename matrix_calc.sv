module matrix_calc #(
    parameter N      = 4,    // размер матрицы N×N
    parameter DATA_W = 16    // разрядность элемента (знаковое целое)
) (
    // ── Системные сигналы ─────────────────────────────────────
    input  logic          clk,
    input  logic          rst_n,        // сброс, активный низкий

    // ── APB Slave (управление) ────────────────────────────────
    input  logic          psel,
    input  logic          penable,
    input  logic          pwrite,
    input  logic [7:0]    paddr,
    input  logic [31:0]   pwdata,

    // Выходы APB
    output logic [31:0]   prdata,
    output logic          pready,       // всегда 1 в данном дизайне
    output logic          pslverr,

    // Управление вычислениями
    output logic [1:0]    op,
    output logic          start,        

    // Входы для битов статуса
    input  logic          done_i,
    input  logic          busy_i,      
    input  logic          overflow_i,
    input  logic          singular_i,

    // ── AXI4-Stream Slave: матрица A ──────────────────────────
    axis_if.slave         axis_bus_a,

    // ── AXI4-Stream Slave: матрица B ──────────────────────────
    axis_if.slave         axis_bus_b,

    // ── AXI4-Stream Master: результат ─────────────────────────
    axis_if.master        axis_bus_res
);

    // Здесь будет размещаться вся логика твоего калькулятора (вызов datapath, FSM и APB CSR)

endmodule