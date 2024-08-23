module hamming74_enc(i_data, o_hamming_code, o_parity);

input [3:0] i_data;
output [6:0] o_hamming_code;
output o_parity;

reg p1,p2,p4;

always@(*)
     begin
	p1 = i_data[0] ^ i_data[1] ^ i_data[3];
	p2 = i_data[0] ^ i_data[1] ^ i_data[3];
	p4 = i_data[0] ^ i_data[1] ^ i_data[3];
     end

//i/p  : d3 d2 d1    d0
//o/p  : d7 d6 d5 p4 d3 p2 p1
assign o_hamming_code = {i_data[3:1],p4,i_data[0],p2,p1};

//create the optional parity bit
assign o_parity = ^o_hamming_code;

endmodule

