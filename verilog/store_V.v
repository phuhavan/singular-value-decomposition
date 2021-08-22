// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module store_V
#(
	parameter data_width = 24,						// Do rong du lieu cua 1 phan tu nho
	parameter no_of_row=2,							// Dia chi hang
	parameter no_of_col=2,							// Dia chi cot
	parameter max_no_of_row_col=3,				// alway is 3
	parameter addr_width = 6						// |1bit|3bit|2bit| *1bit: xac dinh hang/|cot *3bit:hang  *2bit:cot
)
(	
	input																clk,rst_n,
	input																we,			// we/|(re) = 1 la ghi, = 0 la doc
	input			[addr_width-1:0]								addr,
	input			[2*data_width*(2**max_no_of_row_col)-1:0]data_in,
	output		[2*data_width*(2**max_no_of_row_col)-1:0]data_out
);
	integer						i,j;
	
	wire							en;
	wire [2:0]row;
	//wire [2:0]col;
	
	assign en=!addr[5];
	assign row=addr[1:0];
	//assign col=addr[4:2];
	
	reg	[data_width-1:0]	ram	[2**no_of_row-1:0][2**no_of_col-1:0];// store element
	
	wire	[data_width*(2**max_no_of_row_col)-1:0]	data_in_H;
	wire	[data_width*(2**max_no_of_row_col)-1:0]	data_in_L;
	wire 	[data_width*(2**max_no_of_row_col)-1:0]	data_out_H;
	wire 	[data_width*(2**max_no_of_row_col)-1:0]	data_out_L;
	
	wire	[data_width-1:0]data_in_H_mul [0:2**max_no_of_row_col-1];
	wire	[data_width-1:0]data_in_L_mul [0:2**max_no_of_row_col-1];
	reg	[data_width-1:0]data_out_H_mul[0:2**max_no_of_row_col-1];
	reg	[data_width-1:0]data_out_L_mul[0:2**max_no_of_row_col-1];
	
	assign data_in_L	=data_in[2*data_width*(2**max_no_of_row_col)-1:data_width*(2**max_no_of_row_col)];
	assign data_in_H	=data_in[  data_width*(2**max_no_of_row_col)-1:							     		  0];
	assign data_out	={data_out_L,data_out_H};

	assign data_in_H_mul[0]= data_in_H [1*data_width-1:0*data_width];
	assign data_in_H_mul[1]= data_in_H [2*data_width-1:1*data_width];
	assign data_in_H_mul[2]= data_in_H [3*data_width-1:2*data_width];
	assign data_in_H_mul[3]= data_in_H [4*data_width-1:3*data_width];
	assign data_in_H_mul[4]= data_in_H [5*data_width-1:4*data_width];
	assign data_in_H_mul[5]= data_in_H [6*data_width-1:5*data_width];
	assign data_in_H_mul[6]= data_in_H [7*data_width-1:6*data_width];
	assign data_in_H_mul[7]= data_in_H [8*data_width-1:7*data_width];
	
	assign data_in_L_mul[0]= data_in_L [1*data_width-1:0*data_width];
	assign data_in_L_mul[1]= data_in_L [2*data_width-1:1*data_width];
	assign data_in_L_mul[2]= data_in_L [3*data_width-1:2*data_width];
	assign data_in_L_mul[3]= data_in_L [4*data_width-1:3*data_width];
	assign data_in_L_mul[4]= data_in_L [5*data_width-1:4*data_width];
	assign data_in_L_mul[5]= data_in_L [6*data_width-1:5*data_width];
	assign data_in_L_mul[6]= data_in_L [7*data_width-1:6*data_width];
	assign data_in_L_mul[7]= data_in_L [8*data_width-1:7*data_width];

	assign data_out_H[1*data_width-1:0*data_width]= data_out_H_mul[0];
	assign data_out_H[2*data_width-1:1*data_width]= data_out_H_mul[1];
	assign data_out_H[3*data_width-1:2*data_width]= data_out_H_mul[2];
	assign data_out_H[4*data_width-1:3*data_width]= data_out_H_mul[3];
	assign data_out_H[5*data_width-1:4*data_width]= data_out_H_mul[4];
	assign data_out_H[6*data_width-1:5*data_width]= data_out_H_mul[5];
	assign data_out_H[7*data_width-1:6*data_width]= data_out_H_mul[6];
	assign data_out_H[8*data_width-1:7*data_width]= data_out_H_mul[7];
	
	assign data_out_L[1*data_width-1:0*data_width]= data_out_L_mul[0];
	assign data_out_L[2*data_width-1:1*data_width]= data_out_L_mul[1];
	assign data_out_L[3*data_width-1:2*data_width]= data_out_L_mul[2];
	assign data_out_L[4*data_width-1:3*data_width]= data_out_L_mul[3];
	assign data_out_L[5*data_width-1:4*data_width]= data_out_L_mul[4];
	assign data_out_L[6*data_width-1:5*data_width]= data_out_L_mul[5];
	assign data_out_L[7*data_width-1:6*data_width]= data_out_L_mul[6];
	assign data_out_L[8*data_width-1:7*data_width]= data_out_L_mul[7];
	

	always @ (posedge clk)begin
		if (rst_n == 0) begin
			for (i=0; i<2**no_of_row; i=i+1) begin
				for (j=0; j<2**no_of_col; j=j+1) begin
					if (i==j) ram[i][j] <= 24'd65536;
					else ram[i][j] <= 'b0;
				end
			end
		end else if(en)begin // row
			if (we) begin
				for(i=0; i<2**no_of_col; i=i+1) begin
					ram[row  ][i] <= data_in_H_mul[i];
					ram[row+1][i] <= data_in_L_mul[i];
				end
			end else begin
				for(i=0; i<2**no_of_col; i=i+1) begin
					data_out_H_mul[i] <= ram[row  ][i];
					data_out_L_mul[i] <= ram[row+1][i];
				end
			end
		end /*else if  (en) begin // col
			if (we) begin
				for (i=0; i< 2**no_of_row; i=i+1) begin
					ram[i][col  ]<= data_in_H_mul[i];
					ram[i][col+1]<= data_in_L_mul[i];
				end
			end else begin
				for (i=0; i< 2**no_of_row; i=i+1) begin
					data_out_H_mul[i]<=ram[i][col  ];
					data_out_L_mul[i]<=ram[i][col+1];
				end
			end
		end*/
	end
endmodule 
