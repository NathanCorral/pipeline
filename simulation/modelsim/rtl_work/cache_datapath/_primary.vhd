library verilog;
use verilog.vl_types.all;
entity cache_datapath is
    generic(
        way             : integer := 2;
        data_words      : integer := 8;
        lines           : integer := 8
    );
    port(
        clk             : in     vl_logic;
        mem_rdata       : out    vl_logic_vector(15 downto 0);
        mem_read        : in     vl_logic;
        mem_write       : in     vl_logic;
        mem_byte_enable : in     vl_logic_vector(1 downto 0);
        mem_address     : in     vl_logic_vector(15 downto 0);
        mem_wdata       : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        pmem_resp       : in     vl_logic;
        pmem_rdata      : in     vl_logic_vector(127 downto 0);
        pmem_read       : in     vl_logic;
        pmem_address    : out    vl_logic_vector(15 downto 0);
        pmem_wdata      : out    vl_logic_vector(127 downto 0);
        dirty           : out    vl_logic;
        hit             : out    vl_logic;
        sel_way_mux     : in     vl_logic;
        pmem_mux_sel    : in     vl_logic;
        mem_resp        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of way : constant is 1;
    attribute mti_svvh_generic_type of data_words : constant is 1;
    attribute mti_svvh_generic_type of lines : constant is 1;
end cache_datapath;
