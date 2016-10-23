library verilog;
use verilog.vl_types.all;
entity stall is
    port(
        read            : in     vl_logic;
        write           : in     vl_logic;
        resp            : in     vl_logic;
        stall           : out    vl_logic
    );
end stall;
