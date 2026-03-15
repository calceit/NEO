// Memory Module - Stores signal data and results
module memory #(parameter N = 7, parameter M = 63)(input logic clk, nRst, writeEnable, 
input logic [$clog2(M+1)-1:0] raddr, 
output logic [N:0] rdata, 
input logic [$clog2(M+1)-1:0] waddr, input logic [N:0] wdata 
 );
logic [N:0] mem [0:M];

always_ff @(posedge clk, negedge nRst) begin
        if (!nRst) begin
            $readmemb("sine_data_case3.txt", mem);
        end
        else begin
            if (writeEnable) begin
                mem[waddr] <= wdata;
            end
        end
    end
always_ff @(posedge clk) begin
	rdata <= mem[raddr];
end

endmodule
// End of Memory Module
