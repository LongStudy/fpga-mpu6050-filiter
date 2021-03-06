module iic_calculate(
     clk,
	  rst,
	  AX,
	  AY,
	  AZ,
	  GX,	
	  GY,
	  GZ,
	  TP,
	  is_read,
	  data,
	  is_send,
	  is_done,
	  dir
	 );
	 
    input [15:0]AX;
	 input [15:0]AY;
	 input [15:0]AZ;
	 input [15:0]GX;
	 input [15:0]GY;
	 input [15:0]GZ;
	 input [15:0]TP;
    input is_read,is_done;
    input clk,rst;
    output is_send;
	 output [7:0]data;
	 output [1:0]dir;
	
	 wire [31:0] dataU1,dataU2,dataU3;
	 wire [31:0] gy_speed,AZangle,angle;
	 wire cal_done;
	 
	 cal_gy B1(
	   .clk(clk),
		.rst(rst),
		.GY(GY),
		.is_read(is_read),
		.gy_speed(gy_speed),
		.data(dataU1)
		);
	
	
	 cal_AZangle B2(
	   .clk(clk),
		.rst(rst),
		.AX(AX),
		.AZ(AZ),
		.AZangle(AZangle),
		.is_read(is_read),
		.cal_done(cal_done),
		.data(dataU2)
		);
		
	 fiter B3(
	   .clk(clk),
		.rst(rst),
		.cal_done(cal_done),
		.angle(angle),
		.AZangle(AZangle),
		.gy_speed(gy_speed),
		.dir(dir),
		.data(dataU3)
		);
	
	 iic_uart B4(
	   .clk(clk),
		.rst(rst),
		.fclk(32'd4999999),
		.data_in(dataU3),
		.uart_data(data),
		.is_send(is_send),
		.is_done(is_done)
		);

	
				
endmodule 