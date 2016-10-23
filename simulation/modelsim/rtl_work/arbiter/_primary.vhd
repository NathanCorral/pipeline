library verilog;
use verilog.vl_types.all;
entity arbiter is
    port(
        clk             : in     vl_logic;
        icache_pmem_read: in     vl_logic;
        icache_pmem_address: in     vl_logic_vector(15 downto 0);
        dcache_pmem_read: in     vl_logic;
        dcache_pmem_write: in     vl_logic;
        dcache_pmem_address: in     vl_logic_vector(15 downto 0);
        dcache_pmem_wdata: in     vl_logic_vector(127 downto 0);
        pmem_resp       : in     vl_logic;
        pmem_rdata      : in     vl_logic_vector(127 downto 0);
        dcache_mem_rdata: out    vl_logic_vector(127 downto 0);
        icache_mem_rdata: out    vl_logic_vector(127 downto 0);
        dcache_mem_resp : out    vl_logic;
        icache_mem_resp : out    vl_logic;
        pmem_read       : out    vl_logic;
        pmem_write      : out    vl_logic;
        pmem_address    : out    vl_logic_vector(15 downto 0);
        pmem_wdata      : out    vl_logic_vector(127 downto 0)
    );
end arbiter;
