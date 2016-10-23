library verilog;
use verilog.vl_types.all;
entity cache_control is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        sel_way_mux     : out    vl_logic;
        pmem_mux_sel    : out    vl_logic;
        pmem_read       : out    vl_logic;
        pmem_write      : out    vl_logic;
        mem_read        : in     vl_logic;
        mem_write       : in     vl_logic;
        hit             : in     vl_logic;
        dirty           : in     vl_logic;
        pmem_resp       : in     vl_logic
    );
end cache_control;
