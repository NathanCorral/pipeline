module or2input
(
	input way0,way1,
	output out
);

assign out = way0 | way1;

endmodule: or2input