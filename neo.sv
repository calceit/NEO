// NEO Accelerator Module - Calculates Teager Energy Operator
module neo #(parameter N = 7)(
    input  logic        clk,
    input  logic        nRst,
    input  logic [N:0]  x_in,
    output logic [N:0]  neo_out,
    output logic        valid
);

    logic [N:0] x_n_minus_1;
    logic [N:0] x_n_minus_2;
    
    always_ff @(posedge clk, negedge nRst) begin
        if (!nRst) begin
            x_n_minus_1 <= '0;
            x_n_minus_2 <= '0;
        end
        else begin
            x_n_minus_2 <= x_n_minus_1;
            x_n_minus_1 <= x_in;
        end
    end
    
    wire signed [3:0] x_curr  = x_in[3:0];
    wire signed [3:0] x_prev1 = x_n_minus_1[3:0];
    wire signed [3:0] x_prev2 = x_n_minus_2[3:0];
    
    logic signed [7:0] squared;         
    logic signed [7:0] product;         
    logic signed [8:0] result;          
    
    always_ff @(posedge clk, negedge nRst) begin
        if (!nRst) begin
            squared <= 8'sd0;
            product <= 8'sd0;
            result  <= 9'sd0;
            neo_out <= 8'd0;
        end
        else begin
            squared <= x_prev1 * x_prev1;
            product <= x_curr * x_prev2;
            result  <= squared - product;
            
            if (result > 8'sd127)
                neo_out <= 8'd127;
            else if (result < -128)
                neo_out <= 8'd128;
            else
                neo_out <= result[7:0];
        end
    end
    
    logic [2:0] count;
    
    always_ff @(posedge clk, negedge nRst) begin
        if (!nRst)
            count <= 3'b000;
        else if (count < 3'b100)
            count <= count + 1'b1;
    end
    
    assign valid = (count >= 3'b100);

endmodule
// End of NEO Module
