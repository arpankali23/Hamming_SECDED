

`define ERROR    1
`define NO_ERROR 0


module tb_hamming74_enc_dec();

    
    reg  [3:0]     i_secded;
    reg  [4:0]     i_noise;	
	
	wire [6:0]     o_7seg;
	wire [3:0]     o_secded;   
	wire           o_1bit_error;
    wire           o_2bit_error;
	wire           o_parity_error;
	
   
    integer success_count = 0, error_count = 0, test_count = 0, i = 0;

		
	hamming_secded SECDED0( 
		.i_secded (i_secded), 
		.i_noise(i_noise),
		.o_7seg(o_7seg),  
		.o_secded(o_secded),	
		.o_1bit_error(o_1bit_error),
		.o_2bit_error(o_2bit_error),
		.o_parity_error(o_parity_error));
	
	
	initial begin
        $display($time, " TEST START");
       
        $display($time, "\n TEST1: NO bit error");
		for(i=0; i<16; i=i+1) begin
		   i_secded = i[3:0]; i_noise = 0;
		   #1; compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);		   
	    end
		
		#10;    
		$display($time, "\n TEST2: 1bit error");
		for(i=0; i<=16; i=i+1) begin
		    i_secded = i[3:0]; 
		    i_noise = (i==16) ? 5'b10000 : $urandom_range(7,1);
		    #1;
            if(i<16)		   
				compare_data(i_secded, o_secded, `ERROR, `NO_ERROR, `NO_ERROR);
            else
				compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `ERROR);  // trigger a parity error			
	    end
		
		
        #10;    
		$display($time, "\n TEST3: 2bit error");		
		for(i=0; i<16; i=i+1) begin
		   i_secded = i[3:0]; 
		   i_noise = (1 << 3) | $urandom_range(7,1);
		   #1; compare_data(i_secded, o_secded, `NO_ERROR, `ERROR, `NO_ERROR);
	    end
		
		
		
		#10;    
	    $display($time, "\n TEST4: Parity altered + 2bit error = 3bit error (Not correctable, partially detectable)");		
	    i_secded = 4'd8; 
        i_noise = (1 << 4) | (1 << 3) | $urandom_range(7,1);
		#1; i_secded = 0; i_noise = 0;
		
		
		#10;    
		$display($time, "\n TEST5: NO bit error (again)");		
		i_secded = 4'b1010; i_noise = 0;
		#1; compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);	
		
		#10;    
		
		
        $display($time, " TEST STOP. \n\t\t RESULTS success_count = %0d, error_count = %0d, test_count = %0d", 
		                 success_count, error_count, test_count);		
	    $stop;
	end
	
	
	task compare_data(input [3:0] i_secded, input [3:0] o_secded, input exp_1bit_error, input exp_2bit_error, input exp_parity_error);
	begin : cmp_data
		reg [6:0] exp_hamming74;
		
		
		if (!exp_2bit_error) begin
			if ({i_secded, exp_1bit_error, exp_parity_error} === {o_secded, o_1bit_error, o_parity_error}) begin
				$display($time, " SUCCESS \t i_secded = %b, o_secded = %b, 1bit_error = %b, parity_error = %b | SECDED_IN = %b | SECDED_OUT = %b", 
								  i_secded, o_secded, exp_1bit_error, exp_parity_error, i_secded, o_secded);
				success_count = success_count + 1;
			end else begin
				$display($time, " ERROR \t i_secded = %b, o_secded = %b, 1bit_error = %b, parity_error = %b  | SECDED_IN = %b | SECDED_OUT = %b", 
								  i_secded, o_secded, exp_1bit_error, exp_parity_error, i_secded, o_secded);
				error_count = error_count + 1;
			end
		end else begin
			if (exp_2bit_error === o_2bit_error) begin
				$display($time, " SUCCESS \t i_secded = %b, o_secded = %b, 2bit_error = %b | SECDED_IN = %b | SECDED_OUT = %b", 
								  i_secded, o_secded, exp_2bit_error, i_secded, o_secded);
				success_count = success_count + 1;
			end else begin
				$display($time, " ERROR \t i_secded = %b, o_secded = %b, 2bit_error = %b | SECDED_IN = %b | SECDED_OUT = %b", 
								  i_secded, o_secded, exp_2bit_error, i_secded, o_secded);
				error_count = error_count + 1;
			end
		end
		test_count = test_count + 1;	
	end	: cmp_data		
	endtask
	
endmodule


	
		

	   




	     
	


