`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  petproject
// Engineer: j4zzb4ss
// 
// Create Date: 01.05.2026 19:06:08
// Design Name: a
// Module Name: apb_csr
// Project Name:  matrixCalc
// Target Devices: 
// Tool Versions: 
// Description: Advanced Peripheral Bus - Control and Status Registers. Блок, через который мастер на шине общается с калькулятором.
// Здесь три регистра: кода операции, контроля и статуса операции.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module apb_csr(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [7:0]  paddr,
    input  logic [31:0] pwdata,

    //выходы
    output logic [31:0] prdata,
    output logic        pready,       // всегда 1 в данном дизайне
    output logic        pslverr,

    //
    output logic [1:0]  op,
    output logic        start,       

    //Входы для битов статуса
    input  logic        done_i,
    input  logic        busy_i,      
    input  logic        overflow_i,
    input  logic        singular_i,

    );

    localparam  ADDR_OP     = 8'h00;
    localparam  ADDR_CTRL   = 8'h04;
    localparam  ADDR_STATUS = 8'h08;

    //Биты регистров:
    // REG_OP: Код операции [1:0] OP 2'b00 - сложение
    logic [31:0] REG_OP;
    // REG_CTRL: Флажок запуска вычисления [0] START (при 1 запуск)
    logic [31:0] REG_CTRL;
    // REG_STATUS: [0] DONE; [1] BUSY; [2] OVERFLOW; [3] SINGULAR
    // logic [31:0] REG_STATUS; Это вроде не нужно, так как запоминать статус не нужно, просто смотреть сквозь блок на вычислительные блоки

    logic rw; // Если 1, то write
    logic waiter;


    // Запись
    always_ff @(posedge clk or negedge rst_n) begin : WriteInRegisters
        if (!rst_n) begin
            REG_OP     <= '0;
            REG_CTRL   <= '0;
        end
        else if (psel & penable & pwrite) begin
            case (paddr)
                ADDR_OP  : REG_OP     <= pwdata; 
                ADDR_CTRL: REG_CTRL   <= pwdata;
                default: ;
            endcase
        end
        else if (REG_CTRL[0] == 1'b1) 
            REG_CTRL <= 8'h00;
    end
    

    // Логика чтения и обработки ошибок
    always_comb begin
        prdata  = 32'h0;
        pslverr = 1'b0;

        // Нас интересует только момент, когда мастер обратился к модулю (psel)
        // и транзакция перешла в активную фазу (penable)
        if (psel && penable) begin
            case (paddr)
                ADDR_OP: begin
                    if (!pwrite) prdata = REG_OP;
                end

                ADDR_CTRL: begin
                    if (!pwrite) prdata = REG_CTRL;
                end

                ADDR_STATUS: begin
                    if (!pwrite) 
                        prdata = {28'h0, singular_i, overflow_i, busy_i, done_i};
                    else 
                        pslverr = 1'b1; // Ошибка: попытка записи в Read-Only регистр статуса
                end

                default: begin
                    pslverr = 1'b1; // Ошибка: обращение к несуществующему адресу
                end
            endcase
        end
    end

    assign op     = REG_OP[1:0];
    assign start  = REG_CTRL[0];
    assign pready = 1'b1; // Всегда в 1


    
endmodule
