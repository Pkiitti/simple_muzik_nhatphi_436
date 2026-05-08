# SIMPLE MUZIK - OFFLINE MUSIC PLAYER

---

## GIỚI THIỆU DỰ ÁN
Simple Muzik là một ứng dụng phát nhạc offline chuyên nghiệp được phát triển trên nền tảng Flutter. Ứng dụng mang đến trải nghiệm nghe nhạc mượt mà, giao diện hiện đại mang phong cách Dark Mode và khả năng quản lý thư viện âm thanh toàn diện ngay trên thiết bị di động.

Demo: https://drive.google.com/drive/folders/1fHC9AEpOUWFGhPetvviB5U9yOCxdwLxF?usp=sharing
---

## TÍNH NĂNG NỔI BẬT

* **Quản lý thư viện nhạc:** Tự động quét các tệp âm thanh có sẵn trong thiết bị, hỗ trợ công cụ tìm kiếm nhanh và sắp xếp thông minh theo Tên bài, Nghệ sĩ hoặc Ngày thêm mới nhất.

<img width="366" height="713" alt="image" src="https://github.com/user-attachments/assets/16551358-c6c2-4c1d-abf3-057c200278b2" />

* **Quản lý Playlist cá nhân:** Người dùng có thể tự do tạo mới, đổi tên, xóa danh sách phát, cũng như thêm/bớt các bài hát yêu thích vào Playlist dễ dàng.

<img width="376" height="712" alt="image" src="https://github.com/user-attachments/assets/ea7cd21f-a9e2-4d01-805f-a754206038fe" />

* **Điều khiển âm thanh toàn diện:** Đầy đủ các thao tác cơ bản (Phát, Tạm dừng, Chuyển bài, Tua). Tích hợp thanh trượt điều chỉnh âm lượng (Volume) và thay đổi tốc độ phát nhạc (từ 0.5x đến 2.0x).

<img width="365" height="726" alt="image" src="https://github.com/user-attachments/assets/596cb9ae-eaa3-4d21-8704-c5716a810040" />

* **Các chế độ phát nhạc:** Hỗ trợ Trộn bài (Shuffle) ngẫu nhiên và Lặp lại (Repeat All, Repeat One, Repeat Off).

<img width="323" height="203" alt="image" src="https://github.com/user-attachments/assets/8d66ae73-85b6-42e8-af5c-3667858150f2" />

* **Phát nhạc chạy nền (Background Playback):** Âm nhạc không bao giờ dừng lại. Ứng dụng tiếp tục phát nhạc ngay cả khi bị ẩn xuống nền hoặc khi khóa màn hình, kèm theo trình điều khiển trực tiếp trên thanh thông báo hệ thống.

<img width="376" height="671" alt="image" src="https://github.com/user-attachments/assets/47402566-c875-4375-98fd-84e1adfd232c" />

* **Lưu trữ trạng thái thông minh:** Ứng dụng tự động ghi nhớ bài hát đang nghe dở, vị trí thời gian bài hát, cấu hình âm lượng và danh sách Playlist. Khi khởi động lại, mọi thứ vẫn ở nguyên vị trí cũ.

---

## CÔNG NGHỆ VÀ THƯ VIỆN SỬ DỤNG

- **Ngôn ngữ & Khung làm việc:** Dart, Flutter
- **Quản lý trạng thái:** Provider
- **Lõi xử lý âm thanh:** just_audio, just_audio_background, audio_service
- **Truy xuất dữ liệu thiết bị:** on_audio_query, permission_handler
- **Lưu trữ dữ liệu cục bộ:** shared_preferences
- **Tiện ích lập trình phản ứng:** rxdart

---

## CẤU TRÚC THƯ MỤC

- **models/**: Định nghĩa cấu trúc dữ liệu cho bài hát và danh sách phát.
- **providers/**: Bộ não xử lý logic và quản lý trạng thái của Audio và Playlist.
- **screens/**: Giao diện các màn hình chính (Home, Now Playing, Playlists...).
- **services/**: Các dịch vụ cốt lõi (xử lý trình phát nhạc, xin quyền, quét nhạc).
- **widgets/**: Các thành phần giao diện tái sử dụng (Song Tile, Mini Player...).
- **main.dart**: Điểm khởi chạy ứng dụng, cấu hình dịch vụ nền.

---

## HƯỚNG DẪN CÀI ĐẶT VÀ SỬ DỤNG

1. Clone hoặc tải mã nguồn về máy tính.
2. Mở terminal tại thư mục dự án và chạy lệnh: flutter pub get để tải các thư viện.
3. Kết nối thiết bị Android thật hoặc máy ảo. Đảm bảo thiết bị đã có sẵn một số tệp nhạc mp3.
4. Khởi chạy ứng dụng bằng lệnh: flutter run
5. Ở lần mở đầu tiên, hãy cấp quyền truy cập bộ nhớ khi ứng dụng yêu cầu để hệ thống có thể quét nhạc.
