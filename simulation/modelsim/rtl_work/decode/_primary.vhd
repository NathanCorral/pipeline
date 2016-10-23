library verilog;
use verilog.vl_types.all;
library work;
entity decode is
    port(
        instruction     : in     vl_logic_vector(15 downto 0);
        sr1_sel         : out    vl_logic;
        sr2_sel         : out    vl_logic;
        sh6_sel         : out    vl_logic;
        imm_sel         : out    vl_logic;
        alumux1_sel     : out    vl_logic_vector(1 downto 0);
        alumux2_sel     : out    vl_logic_vector(1 downto 0);
        alu_ctrl        : out    work.lc3b_types.lc3b_aluop;
        indirect        : out    vl_logic;
        read            : out    vl_logic;
        write           : out    vl_logic;
        mem_byte_sig    : out    vl_logic_vector(1 downto 0);
        load_regfile    : out    vl_logic;
        regfilemux_sel  : out    vl_logic_vector(1 downto 0);
        load_cc         : out    vl_logic;
        destmux_sel     : out    vl_logic;
        pcmux_sel       : out    vl_logic_vector(1 downto 0);
        pcmux_sel_out_sel: out    vl_logic
    );
end decode;
