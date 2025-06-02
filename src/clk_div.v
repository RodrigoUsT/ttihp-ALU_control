module clk_div (
    input clk,
    output slow_clk
);
    reg [23:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
    end

    assign slow_clk = counter[23];
endmodule
