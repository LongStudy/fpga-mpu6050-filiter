module GY521(
	clk,rst,scl,sda,tx,tx2
    );
	 
input clk,rst;
output scl,tx,tx2;
inout sda;


wire [7:0]uart_data;   //发到串口的数据
wire is_send;     //串口工作使能，一直为高才行
wire is_done;     //串口发送结束信号
wire init_done;
wire [15:0] AX;   //读取模块发送到计算模块
wire [15:0] AY;
wire [15:0] AZ;
wire [15:0] GX;
wire [15:0] GY;
wire [15:0] GZ;
wire [31:0] gx_32; 
wire [31:0] gy_32;
wire [31:0] gz_32; 
wire [15:0] gx;
wire [15:0] gy;
wire [15:0] gz;
		
mpu6050 U1(
   .rst_n(rst),
	.clk(clk),
	.sda(sda),
	.scl(scl),
	.init_done(init_done),
	.ACC_X(AX),
	.ACC_Y(AY),
	.ACC_Z(AZ),
	.GYRO_X(GX),
	.GYRO_Y(GY),
	.GYRO_Z(GZ),
);

uart_tx U2(
   .rst_n(rst),
	.clk(clk),
	.tx_data(uart_data),
	.tx_pin(tx),
   .tx_data_valid(is_send),
	.tx_data_ready(is_done)
	);
	
clk_200hz U3(
   .rst(rst),
	.clk(clk),
	.is_read(is_read),
	.init_done(init_done),
	);


cal_gy cal_x(
   .rst(rst),
	.clk(clk),
	.is_read(is_read),
	.G(GX),
	.g_speed(gx_32),
	.gy(gx)
	);

cal_gy cal_y(
   .rst(rst),
	.clk(clk),
	.is_read(is_read),
	.G(GY),
	.g_speed(gy_32),
	.gy(gy)
	); 
	
cal_gy cal_z(
   .rst(rst),
	.clk(clk),
	.is_read(is_read),
	.G(GZ),
	.g_speed(gz_32),
	.gy(gz)
	);
	
iic_uart U5(
	  .rst(rst),
	  .clk(clk),
	  .data_32_1(gx_32),
	  .data_32_2(gy_32),
	  .data_32_3(gz_32),
	  .data_16_1(gx),
	  .data_16_2(gy),
	  .data_16_3(gz),
	  .uart_data(uart_data),
	  .is_send(is_send),
	  .is_done(is_done)
	 );

assign tx2= tx;
	 
endmodule
