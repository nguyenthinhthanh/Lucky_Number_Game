🎡 Lucky Spin Game

Mô tả dự án
Trò chơi vòng quay may mắn được viết bằng Verilog và chạy trên bo mạch Arty Z7. Dự án sử dụng LED để hiển thị kết quả và các nút nhấn để điều khiển. Ngoài ra, thuật toán thông minh giúp điều chỉnh xác suất thắng dựa trên kết quả trước đó, làm tăng tính thú vị và thách thức cho người chơi.

🎯 Chức năng chính  
Quay số ngẫu nhiên: LED sẽ nhấp nháy như một vòng quay và dừng lại ở số được chọn.  
Điều chỉnh xác suất thắng: Tăng xác suất xuất hiện của các số ít được chọn, giảm xác suất của các số được chọn nhiều lần.  
Điều khiển bằng nút nhấn:  
  Nút Start: Bắt đầu vòng quay.  
  Nút Reset: Đặt lại trò chơi.  
📋 Yêu cầu phần cứng và phần mềm  
Phần cứng  
  Bo mạch Arty Z7  
  10 LED (hoặc sử dụng LED tích hợp trên bo)  
  2 nút nhấn (hoặc nút tích hợp trên bo):  
  Nút Start (nút BTN0)  
  Nút Reset (nút BTN1)  
Phần mềm  
  Vivado Design Suite (Phiên bản ≥ 2022.2)  
  Kiến thức cơ bản về ngôn ngữ Verilog.  
🚀 Cách triển khai
1. Clone repository
  git clone https://github.com/nguyenthinhthanh/Lucky_Number_Game
2. Mở Vivado và tạo dự án
Tạo một dự án mới trong Vivado với tên LuckySpinGame.
Chọn bo mạch Arty Z7 
Thêm các tệp .v trong thư mục src vào dự án.
3. Synthesize và implement
Thực hiện Synthesis.
Thực hiện Implementation.
4. Generate bitstream và lập trình bo
Tạo tệp .bit.
Lập trình tệp .bit lên bo thông qua cổng JTAG.
💡 Hướng dẫn sử dụng
Cấp nguồn cho bo Arty Z7.
Nhấn nút BTN0-BTN4, kết hợp Lcd để bắt đầu trò chơi.
LED sẽ nhấp nháy và dừng lại, hiển thị số bạn đã quay được.
Sử dụng nút Reset (SWO) để khởi động lại trò chơi.
✨ Tính năng mở rộng
Hiển thị số quay được trên màn hình 7 đoạn.
Thêm âm thanh (buzzer) khi vòng quay dừng lại.
Tích hợp thuật toán nâng cao để phân tích kết quả trước để thay đổi xác suất trúng số.
🤝 Đóng góp
Bạn có ý tưởng cải thiện trò chơi? Hãy mở Pull Request hoặc Issue trên GitHub!

📄 Giấy phép
Null.
