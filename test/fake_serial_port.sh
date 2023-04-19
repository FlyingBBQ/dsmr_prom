#!/usr/bin/env bash

PORT0=/tmp/ttyUSB0
PORT1=/tmp/ttyUSB1
PID_FILE=/tmp/socat.pid

fake_data_0 () {
cat >> ${PORT0} << EOF
/KFM5KAIFA-METER

1-3:0.2.8(50)
0-0:1.0.0(230417215556S)
0-0:96.1.1(4530303539303030303034303530383230)
1-0:1.8.1(000157.732*kWh)
1-0:1.8.2(000186.698*kWh)
1-0:2.8.1(000000.000*kWh)
1-0:2.8.2(000000.000*kWh)
0-0:96.14.0(0002)
1-0:1.7.0(00.181*kW)
1-0:2.7.0(00.000*kW)
0-0:96.7.21(00000)
0-0:96.7.9(00000)
1-0:99.97.0(0)(0-0:96.7.19)
1-0:32.32.0(00002)
1-0:32.36.0(00000)
0-0:96.13.0()
1-0:32.7.0(237.4*V)
1-0:31.7.0(001*A)
1-0:21.7.0(00.181*kW)
1-0:22.7.0(00.000*kW)
!3563
EOF
}

fake_data_1 () {
cat >> ${PORT0} << EOF
/KFM5KAIFA-METER

1-3:0.2.8(50)
0-0:1.0.0(230417215558S)
0-0:96.1.1(4530303539303030303034303530383230)
1-0:1.8.1(000157.732*kWh)
1-0:1.8.2(000186.698*kWh)
1-0:2.8.1(000000.000*kWh)
1-0:2.8.2(000000.000*kWh)
0-0:96.14.0(0002)
1-0:1.7.0(00.183*kW)
1-0:2.7.0(00.000*kW)
0-0:96.7.21(00000)
0-0:96.7.9(00000)
1-0:99.97.0(0)(0-0:96.7.19)
1-0:32.32.0(00002)
1-0:32.36.0(00000)
0-0:96.13.0()
1-0:32.7.0(237.3*V)
1-0:31.7.0(001*A)
1-0:21.7.0(00.183*kW)
1-0:22.7.0(00.000*kW)
!5EA7
EOF
}

echo "Starting serial ports ${PORT0} and ${PORT1}"

socat PTY,link=${PORT0} PTY,link=${PORT1} &
echo "$!" > $PID_FILE

while :
do
    fake_data_0;
    sleep 1;
    fake_data_1;
    sleep 1;
done > ${PORT0}

wait