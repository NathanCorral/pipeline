library verilog;
use verilog.vl_types.all;
entity cccomp is
    port(
        nzp             : in     vl_logic_vector(2 downto 0);
        cc              : in     vl_logic_vector(2 downto 0);
        branch_enable   : out    vl_logic
    );
end cccomp;
