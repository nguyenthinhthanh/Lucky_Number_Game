## Lucky Spin Number Game

**Mô tả dự án**  

Trò chơi vòng quay may mắn được viết bằng Verilog và chạy trên bo mạch Arty Z7. Dự án sử dụng LED và LCD 16x2 để hiển thị kết quả và các nút nhấn để điều khiển, kết hợp nhạc để tăng tính thú vị cho trò chơi. Ngoài ra, thuật toán thông minh giúp điều chỉnh xác suất thắng dựa trên kết quả trước đó, làm tăng tính thú vị và thách thức cho người chơi.  

Trò chơi cũng được tích hợp điều khiển từ xa bằng App, sử dụng module ESP32 NodeMCU LuaNode32 nhận dữ liệu thông qua Bluetooth từ App và gửi tới Arty Z7 bằng giao tiếp UART.  

### Mục lục
- [Lucky Spin Number Game](#lucky-spin-number-game)
- [Chức năng chính](#chức-năng-chính)
- [Yêu cầu phần cứng và phần mềm](#yêu-cầu-phần-cứng-và-phần-mềm)
- [Cách triển khai](#cách-triển-khai)
- [Hướng dẫn sử dụng](#hướng-dẫn-sử-dụng)
- [Tính năng mở rộng](#tính-năng-mở-rộng)
- [Đóng góp](#đóng-góp)
- [Giấy phép](#giấy-phép)


## Chức năng chính  
1. **Quay số ngẫu nhiên**:
   - Trò chơi cho phép người chơi lựa chọn chế độ chơi, cách thức chơi, cách thức đặt cược.  
2. **LED**:
   - Nhấp nháy và đổi màu tương ứng với chế độ và trạng thái trò chơi tương ứng.  
3. **Điều chỉnh xác suất thắng**:
   - Tăng xác suất xuất hiện của các số ít được chọn, giảm xác suất của các số được chọn nhiều lần.  
4. **Điều khiển bằng nút nhấn**:  
   - Nút Start: Bắt đầu vòng quay.  
   - Nút Reset: Đặt lại trò chơi.
5. Điều khiển trò chơi qua App kết nối Bluetooth.  
## Yêu cầu phần cứng và phần mềm  
Phần cứng  
  - Bo mạch Arty Z7  
  - 4 LED đơn tích hợp trên bo
  - 2 LED RGB tích hợp trên bo
  - 4 nút nhấn tích hợp trên bo:
  - 1 LCD 16x2 hướng dẫn người chơi và thông báo kết quả  
  - 1 Buzzer active phát nhạc  
  - 1 Module ESP32 NodeMCU LuaNode32
Phần mềm  
  Vivado Design Suite (Phiên bản ≥ 2022.2)  
  Kiến thức cơ bản về ngôn ngữ Verilog.  
## Cách triển khai
1. Clone repository  
```bash
git clone https://github.com/nguyenthinhthanh/Lucky_Number_Game
```
2. **Mở Vivado và tạo dự án**
   - Tạo một dự án mới trong Vivado với tên LuckySpinGame.
   - Chọn bo mạch Arty Z7
   - Thêm các tệp .v trong thư mục src vào dự án.
3. **Synthesize và implement**  
   - Thực hiện Synthesis.
   - Thực hiện Implementation.
4. **Generate bitstream và lập trình bo**
   - Tạo tệp .bit.
   - Lập trình tệp .bit lên bo thông qua cổng JTAG.
## Hướng dẫn sử dụng
Các bước bắt đầu như sau:
- Cấp nguồn cho bo Arty Z7.  

- Nhấn nút BTN0-BTN4, kết hợp Lcd để bắt đầu trò chơi.  

- LCD hiện thị kết quả thắng thua, LED sẽ nhấp nháy, đổi màu và dừng lại, LED 7 đoạn hiển thị số bạn đã quay được.  

- Sử dụng nút Reset (SWO) để khởi động lại trò chơi.  

- Sử dụng Bluetooth terminal để điều khiển trò chơi trên thiết bị.  
## Tính năng mở rộng
Ngoài những tính năng cơ bản, dự án còn mở rộng:  
   - Điều khiển trò chơi bằng App sử dụng module ESP32 NodeMCU LuaNode32 Bluetooth, giao tiếp Uartt.  

   - Thêm nhiều chế độ chơi, cho phép người chơi thiết lập cách chơi và chế độ Special Mode tăng tính hấp dẫn.  

   - Thêm âm thanh (buzzer) phát nhạc trong suốt trò chơi.  

   - Tích hợp thuật toán nâng cao để phân tích kết quả trước để thay đổi xác suất trúng số.  

- Ngoài ra vì được kết nối với ESP32 một module mạnh mẽ, trong tương lai dự án có thể mở rộng hơn rất nhiều.  
## Đóng góp
Bạn có ý tưởng cải thiện trò chơi? Hãy mở Pull Request hoặc Issue trên GitHub!

## Giấy phép
Dự án này được tạo ra **chỉ nhằm mục đích học tập**. Không được sử dụng cho mục đích thương mại.
