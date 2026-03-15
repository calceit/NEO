module neo_top #(
    parameter N = 7,
    parameter M = 15
)(
    input  logic clk,
    input  logic nRst,
    input  logic [$clog2(M+1)-1:0] raddr,
    input  logic [$clog2(M+1)-1:0] waddr,
    input  logic writeEnable,
    output logic [N:0] neo_out,
    output logic neo_valid
);

    // Internal signals
    logic [N:0] rdata;
    logic [N:0] wdata;

    // Memory instance
    memory #(
        .N(N),
        .M(M)
    ) mem_inst (
        .clk(clk),
        .nRst(nRst),
        .writeEnable(),
        .raddr(raddr),
        .rdata(rdata),
        .waddr(waddr),
        .wdata(wdata)
    );

    // NEO instance
    neo #(
        .N(N)
    ) neo_inst (
        .clk(clk),
        .nRst(nRst),
        .x_in(rdata),
        .neo_out(neo_out),
        .valid()
    );

    // Connect NEO output to memory write data
    assign wdata = neo_out;

endmodule
