import lc3b_types::*;

module arbiter
(
    input clk,
    input icache_pmem_read,
    input lc3b_word icache_pmem_address,
    input dcache_pmem_read,
    input dcache_pmem_write,
    input lc3b_word dcache_pmem_address,
    input lc3b_block dcache_pmem_wdata,
    input pmem_resp,
    input lc3b_word pmem_rdata,
    output lc3b_block dcache_mem_rdata,
    output lc3b_block icache_mem_rdata,
    output logic dcache_mem_resp,
    output logic icache_mem_resp,
    output logic pmem_read,
    output logic pmem_write,
    output lc3b_word pmem_address,
    output lc3b_block pmem_wdata
);

always_ff @(posedge clk)
begin
    dcache_mem_rdata <= pmem_rdata;
    icache_mem_rdata <= pmem_rdata;
    dcache_mem_resp <= (dcache_pmem_read | dcache_pmem_write) & pmem_resp;
    icache_mem_resp <= (~dcache_pmem_read | ~dcache_pmem_write) & pmem_resp;
    pmem_read <= dcache_pmem_read | (icache_pmem_read & ~dcache_pmem_write);
    pmem_write <= dcache_pmem_write;
    pmem_wdata <= dcache_pmem_wdata;
    if(dcache_pmem_read || dcache_pmem_write) begin
        pmem_address <= dcache_pmem_address;
    end
    else begin
        pmem_address <= icache_pmem_address;
    end
end

endmodule : arbiter
