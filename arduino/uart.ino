/*
 Name:    Sketch1.ino
 Created: 2021/11/5 20:08:05
 Author:  kcqnly
*/

#include <ESP8266WiFi.h>

//wifi名称和密码
const char* ssid = "nova5";
const char* password = "Suyuan2001";
//const char* ssid = "kcqnly";
//const char* password = "12345678";
String COMdata = "";
//服务器设置为80端口
WiFiServer server(8080);

void setup() {
  //开启串口监视器
  Serial.begin(115200);
  
  //开启wifi:用户名+密码
  WiFi.begin(ssid,password);

  //尝试连接wifi
  while(WiFi.status() != WL_CONNECTED){
    delay(500);
    //Serial.println('.');
    }
  //Serial.println("连接成功");
  //Serial.println(WiFi.localIP());

  //开启服务
  server.begin();
  //Serial.println("Server started"); 
}

void loop() {
 //确定是否连线
 wait:
 WiFiClient client = server.available();
 //Serial.println("未连接上位机APP");
 //判断客户端是否与服务器连上,若没有连接上,则执行if
 if(!client){
  return;
  }
  //Serial.println("已连接上位机APP");
  //客户端是否与服务器连上
  while(client)
  {
    if(!client.status())
      goto wait;
    while (Serial.available() > 0)  
    {
       char temp = Serial.read();
       if(temp == '\r' || temp == '\n') {
//          Serial.println(COMdata);
          client.print(COMdata);
          COMdata = "";
          continue;
        }
       COMdata += temp;
       //delay(1);
    }
//    if (COMdata.length() > 0)
//    {
//       client.println(COMdata);
//       COMdata = "";
//    }
   }
    //Serial.println("已断开");
}
