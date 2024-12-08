#include <BluetoothSerial.h> // Thư viện Bluetooth Serial

BluetoothSerial SerialBT; // Tạo đối tượng Bluetooth Serial

#define UART_TX_PIN 17 // Chân TX của UART (bạn có thể thay đổi)
#define UART_RX_PIN 16 // Chân RX của UART (bạn có thể thay đổi)

void setup() {
  // Khởi động Serial để debug
  Serial.begin(115200); 
  Serial.println("ESP32 đang khởi động...");

  // Cấu hình Bluetooth
  if (!SerialBT.begin("ESP32_BT")) { // Tên Bluetooth là "ESP32_BT"
    Serial.println("Khởi động Bluetooth thất bại!");
    while (true); // Dừng chương trình nếu thất bại
  }
  Serial.println("Bluetooth đã sẵn sàng. Ghép nối với ESP32_BT.");

  // Cấu hình UART (HardwareSerial1) với tốc độ 9600 baud
  Serial1.begin(9600, SERIAL_8N1, UART_RX_PIN, UART_TX_PIN);
  Serial.println("UART đã sẵn sàng.");
}

void loop() {
  // Nếu nhận được dữ liệu từ Bluetooth
  if (SerialBT.available()) {
    String data = SerialBT.readString(); // Đọc dữ liệu từ Bluetooth
    Serial.print("Nhận từ Bluetooth: ");
    Serial.println(data); // Hiển thị trên Serial Monitor

    // Gửi dữ liệu nhận được qua UART
    Serial1.print(data);
    //Serial1.println(); // Thêm ký tự xuống dòng nếu cần
    Serial.println("Dữ liệu đã được gửi qua UART.");
  }

  // Nếu nhận được dữ liệu từ UART
  if (Serial1.available()) {
    String data = Serial1.readString(); // Đọc dữ liệu từ UART
    Serial.print("Nhận từ UART: ");
    Serial.println(data);

    // Gửi dữ liệu nhận được qua Bluetooth
    SerialBT.print(data);
    SerialBT.println();
    Serial.println("Dữ liệu đã được gửi qua Bluetooth.");
  }

  delay(10); // Tránh quá tải CPU
}
