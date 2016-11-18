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
    input l2_pmem_resp,
    input lc3b_block l2_pmem_rdata,
    output lc3b_block dcache_mem_rdata,
    output lc3b_block icache_mem_rdata,
    output logic dcache_mem_resp,
    output logic icache_mem_resp,
    output logic l2_pmem_read,
    output logic l2_pmem_write,
    output lc3b_word l2_pmem_address,
    output lc3b_block l2_pmem_wdata
);

always_comb
begin
    dcache_mem_rdata = l2_pmem_rdata;
    icache_mem_rdata = l2_pmem_rdata;
    dcache_mem_resp = (dcache_pmem_read | dcache_pmem_write) & l2_pmem_resp;
    icache_mem_resp = (~dcache_pmem_read & ~dcache_pmem_write) & l2_pmem_resp & icache_pmem_read;
    l2_pmem_read = dcache_pmem_read | (icache_pmem_read & ~dcache_pmem_write);
    l2_pmem_write = dcache_pmem_write;
    l2_pmem_wdata = dcache_pmem_wdata;
    if(dcache_pmem_read || dcache_pmem_write) begin
        l2_pmem_address = dcache_pmem_address;
    end
    else begin
        l2_pmem_address = icache_pmem_address;
    end
end

endmodule : arbiter
