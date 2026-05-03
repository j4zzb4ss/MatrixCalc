`timescale 1ns/1ps



module axis_driver_wrapper #(
    parameter N      = 4,
    parameter DATA_W = 16
) (
    input logic clk,
    input logic rst_n
);
    
    logic signed [DATA_W-1:0] s_axis_tdata;
    logic                     s_axis_tvalid;
    logic                     s_axis_tlast;
    logic                     s_axis_tready;
    logic                     flash;
    logic signed [DATA_W-1:0] mat [N][N];
    logic                     recv_done;

    // Подключение тестируемого модуля axis_rx
    axis_rx #(
        .N(N),
        .DATA_W(DATA_W)
    ) dut_axis_driver (
        .* // Подключение всех сигналов по совпадению
    );

    // Здесь можно объявлять класс для тестбенча (или использовать вне модуля)
    class axis_driver;
        virtual axis_if vif; 

        function new(virtual axis_if v);
            this.vif = v;
        endfunction

        task send_matrix(input logic [DATA_W - 1:0] m [N][N]);
            $display("[%0t] Отправка матрицы начата", $time);
            
            for (int i = 0; i < N; i++) begin
                for (int j = 0; j < N; j++) begin
                    
                    vif.s_axis_tdata  <= m[i][j];
                    vif.s_axis_tvalid <= 1'b1;
                    
                    if (i == N-1 && j == N-1)
                        vif.s_axis_tlast <= 1'b1;
                    else
                        vif.s_axis_tlast <= 1'b0;

                    @(posedge vif.clk);

                    while (!vif.s_axis_tready) begin
                        @(posedge vif.clk);
                    end
                    
                    $display("[%0t] Элемент [%0d][%0d] отправлен: %0d", $time, i, j, m[i][j]);
                end
            end

            vif.s_axis_tvalid <= 1'b0;
            vif.s_axis_tlast  <= 1'b0;
            @(posedge vif.clk);
            
            $display("[%0t] Матрица успешно отправлена.", $time);
        endtask
    endclass

endmodule