library verilog;
use verilog.vl_types.all;
entity datapath is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        D_mem_address   : out    vl_logic_vector(15 downto 0);
        D_mem_resp      : in     vl_logic;
        D_mem_read      : out    vl_logic;
        D_mem_rdata     : in     vl_logic_vector(15 downto 0);
        D_mem_write     : out    vl_logic;
        mem_byte_enable : out    vl_logic_vector(1 downto 0);
        D_mem_wdata     : out    vl_logic_vector(15 downto 0);
        I_mem_address   : out    vl_logic_vector(15 downto 0);
        I_mem_resp      : in     vl_logic;
        I_mem_read      : out    vl_logic;
        I_mem_rdata     : in     vl_logic_vector(15 downto 0)
    );
end datapath;
