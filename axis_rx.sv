module axis_rx #(
    parameter N      = 4,
    parameter DATA_W = 16
) (
    input logic                       clk,
    input logic                       rst_n,
    axis_if.slave                     axis_bus,
    output logic signed [DATA_W-1:0]  mat [N][N],
    output logic                      recv_done

);

logic [$clog2(N*N)-1:0] cnt;
typedef enum logic {
    IDLE = 1'b0,
    WRITE = 1'b1
} state_t;
state_t state, next_state;

//Синхронный регистр
always_ff @(posedge clk or negedge rst_n) begin

    if(!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

//Комбинационные переходы
always_comb begin
    next_state = state;
    case (state)
        IDLE: if (axis_bus.s_axis_tvalid) next_state = WRITE;
        WRITE: if (recv_done || axis_bus.s_axis_tlast) next_state = IDLE;
    endcase
end

// Комбинационные выходы
always_comb begin
    axis_bus.s_axis_tready = (state == IDLE) || (state == WRITE && !recv_done);
    recv_done = axis_bus.s_axis_tvalid && axis_bus.s_axis_tready && cnt == N*N - 1;
end

//Счётчик
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n || axis_bus.flash)
        cnt <= 0;
    else if (axis_bus.s_axis_tready && axis_bus.s_axis_tvalid) begin
        if (recv_done || axis_bus.s_axis_tlast)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
end

// Запись в матрицу
always_ff @(posedge clk) begin
    if (!rst_n || axis_bus.flash) begin
        for (int i = 0; i < N; i++) begin
            for (int j = 0; j < N; j++) begin
                mat[i][j] <= 0;
            end
        end
    end

    else if(axis_bus.s_axis_tvalid && axis_bus.s_axis_tready)
        mat[cnt / N][cnt % N] <= axis_bus.s_axis_tdata;
end

endmodule