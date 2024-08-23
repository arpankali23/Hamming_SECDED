module noise_add(i_data, i_noise, o_data);

input [7:0] i_data;
input [4:0] i_noise;
output [7:0] o_data;

reg [6:0] noise;

wire [2:0] error_bit;

assign error_bit = i_noise[2:0];

always@(*)
    begin
	case(i_noise[2:0])
	3'd1 : noise = {i_noise[3], 6'b00_0001};
	3'd2 : noise = {i_noise[3], 6'b00_0010};
	3'd3 : noise = {i_noise[3], 6'b00_0100};
	3'd4 : noise = {i_noise[3], 6'b00_1000};
	3'd5 : noise = {i_noise[3], 6'b01_0000};
	3'd6 : noise = {i_noise[3], 6'b10_0000};
	3'd7 : noise = {6'b00_0000, i_noise[3]};
	default : noise = {i_noise[3], 6'b00_0000};
	endcase
    end

assign o_data = i_data ^ {i_noise[4], noise};

endmodule

