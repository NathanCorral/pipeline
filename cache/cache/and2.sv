module and2input
(
	input logic tagcomp,valid,
	output logic out
);

assign out = tagcomp & valid;

endmodule: and2input