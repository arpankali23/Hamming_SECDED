module hamming_secded(input [3:0] i_secded,
		 	input [4:0] i_noise,
			output [6:0] o_7seg,
			output [3:0] o_secded,
			output o_1bit_error,
			output o_2bit_error,
			output o_parity_error);

wire [6:0] enc_hamming_code;
wire  enc_parity;

wire [6:0] o_noise_hamming_code;
wire  o_noise_parity;

wire [6:0] o_syndrome;
wire [2:0] in_7seg;

hamming74_enc hamm_enc_0(.i_data(i_secded),
	                 .o_hamming_code(enc_hamming_code), 
			 .o_parity(enc_parity));

noise_add noise_add_0(.i_data({enc_parity,enc_hamming_code}), 
		      .i_noise(i_noise), 
		      .o_data({o_noise_parity,o_noise_hamming_code}));

hamming74_dec hamm_dec_0(.i_data(o_noise_hamming_code),
		         .i_parity(o_noise_parity),
		         .o_syndrome(o_syndrome),
		         .o_data(o_secded),
		         .o_1bit_error(o_1bit_error),
		         .o_2bit_error(o_2bit_error),
		         .o_parity_error(o_parity_error));

prior_enc pri_enc_0(.d({1'b0,o_syndrome}),
		    .q(in_7seg),
		    .v());

hex_7seg_decoder hex_7(.in({1'b0,in_7seg}),
			.o_a(o_7seg[0]),
			.o_b(o_7seg[1]),
			.o_c(o_7seg[2]),
			.o_d(o_7seg[3]),
			.o_e(o_7seg[4]),
			.o_f(o_7seg[5]),
			.o_g(o_7seg[6]));

endmodule


