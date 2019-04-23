# FPGA读取mpu6050原始数据

## 实验器材:
	黑金ax301
	mpu6050
	
## 硬件接口:
	串口(波特率:115200,RX / TX)
	mpu6050（SCL / SDA）
	
## 说明:
	本实验开机后，先初始化MPU6050，随后读取mpu6050的原始数据（16bit*acc，gyro，共六轴数据），将原始数据直接从串口输出，帧格式：
	send_buf[0]=0XFF;
	send_buf[1]=0XFF;	//帧头
	send_buf[2]=data[0];	//gyrox高8位
	send_buf[3]=data[1];//gyrox低8位
	send_buf[4]=data[2];//gyroy
	send_buf[5]=data[3];
	send_buf[6]=data[4];//gyroz
	send_buf[7]=data[5];
