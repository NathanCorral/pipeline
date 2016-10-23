library verilog;
use verilog.vl_types.all;
entity swap_word is
    generic(
        data_words      : integer := 8
    );
    port(
        data_out        : in     vl_logic_vector(127 downto 0);
        out_word        : out    vl_logic_vector(15 downto 0);
        swap_word       : in     vl_logic_vector(15 downto 0);
        word_offset     : in     vl_logic_vector(2 downto 0);
        swap_data       : out    vl_logic_vector(127 downto 0);
        mem_byte_enable : in     vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of data_words : constant is 1;
end swap_word;
