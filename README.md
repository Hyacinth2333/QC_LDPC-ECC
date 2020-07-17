# QC_LDPC-ECC
NMS_decode

This project realizes the function of ECC in a NAND Flash controller.

Firstly,i construct a H matrix based on QC_LDPC which eliminates 4 rings,this work progresses on the platform of MATLAB;(see in ECC.constructHG folder)
Secondly,realizing the fast encoding unit in hardware,which progresses on the platform of Questa-Sim,using the G matrix corresponding with H matrix;(see in LDPC_ENCODE folder)

Thirdly,simulating the error correction capacity of nms_decode algorithm on the platform of MATLAB,which has a peak correction capacity of 80 bit and a stable
capacity of 75 bit;(see in ECC folder)

Finally,realizing the nms_decode unit in hardware on the platform of Questa-Sim.(see in LDPC_DECODE3.0 folder)





"the size of H matrix is 1024*9216 ,bit rate ups to 0.88888889,the column weight is 3 while the row weight is 27"

The work is finished on June 19,2020,in zhengzhou ,Henan , China and uploaded on July 17,2020,in xi'an ,Shanxi ,China.

For more details , contact me by emailing "m13720759895@163.com"

Sincerely may you successed ,guys    --WXC





