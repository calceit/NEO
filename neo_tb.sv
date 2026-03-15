// NEO Testbench - Verifies NEO operation with memory
module neo_tb;
    parameter N = 7;
    parameter M = 63;
    logic clk;
    logic nRst;
    logic [$clog2(M+1)-1:0] raddr;
    logic [$clog2(M+1)-1:0] waddr;
    logic [N:0] rdata;
    logic [N:0] wdata;
    logic writeEnable;
    logic [N:0] neo_out;
    logic neo_valid;
    memory #(
        .N(N),
        .M(M)
    ) mem_inst (
        .clk(clk),
        .nRst(nRst),
        .writeEnable(writeEnable),
        .raddr(raddr),
        .rdata(rdata),
        .waddr(waddr),
        .wdata(wdata)
    );
    neo #(
        .N(N)
    ) neo_inst (
        .clk(clk),
        .nRst(nRst),
        .x_in(rdata),
        .neo_out(neo_out),
        .valid(neo_valid)
    );
    assign wdata = neo_out;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("neo_memory.vcd");
        $dumpvars(0, neo_tb);
        nRst = 0;
        raddr = 0;
        waddr = 0;
        writeEnable = 0;
        #20;
        nRst = 1;
        $display("Time=%0t: Reset released", $time);
        #10;
        $display("\n Original Memory Contents");
        for (int i = 0; i <= M; i++) begin
            $display("mem[%2d] = %3d (0x%02h) [4-bit signed: %0d]",
                     i,
                     mem_inst.mem[i],
                     mem_inst.mem[i],
                     $signed(mem_inst.mem[i][3:0]));
        end
        $display("\n Processing Memory (Continuous Pipeline)");
        nRst = 0;
        #10;
        nRst = 1;
        writeEnable = 0;
    end
    initial begin : pipeline_driver
        int r_idx, w_idx;
        wait(nRst == 1);
        #1;
        r_idx = 0;
        w_idx = 0;
        while (w_idx <= M) begin
            if (r_idx <= M)
                raddr = r_idx;
            else
                raddr = 0;
            if (neo_valid) begin
                writeEnable = 1;
                waddr = w_idx;
                w_idx++;
            end else begin
                writeEnable = 0;
            end
            @(posedge clk);
            #1;

            if (r_idx <= M + 5)
                r_idx++;
        end
        writeEnable = 0;
      #50;
      $display("\n Final Memory Contents (After NEO) ");
      for (int i = 0; i <= M; i++) begin
            $display("mem[%2d] = %3d (0x%02h) [signed: %0d]", i,
                     mem_inst.mem[i],
                     mem_inst.mem[i],
                     $signed(mem_inst.mem[i]));
        end
        $display("Test Complete!");
        #100;
        $finish;
    end
initial begin
  $dumpvars(0, neo_tb.sv);
  $dumpfile("neo_tb.vcd");
end

always @(posedge clk) begin
    if (neo_valid && writeEnable) begin
        $display("Time=%0t: Wrote mem[%2d] = %3d (NEO Output)", $time, waddr, wdata);
    end
end
endmodule
// End of Testbench
