# Lab 7 — Signup Form

Ứng dụng Flutter đăng ký tài khoản, chạy trên Android và web.

## Chạy Android emulator

Mở PowerShell tại thư mục project:

```powershell
cd C:\Users\DELL\StudioProjects\Lab7
flutter emulators --launch Pixel_5
flutter run -d emulator-5554
```

Nếu emulator đang chạy, bỏ qua lệnh khởi động. Kiểm tra mã thiết bị bằng `flutter devices`.

## Chạy trên Chrome

```powershell
cd C:\Users\DELL\StudioProjects\Lab7
flutter run -d chrome
```

## Tính năng

- Form thích ứng cho điện thoại và màn hình rộng.
- Kiểm tra họ tên, định dạng email, mật khẩu và xác nhận mật khẩu.
- Hiện/ẩn mật khẩu, đánh giá độ mạnh, điều khoản và trạng thái gửi.
- Email có chữ `taken` mô phỏng trường hợp email đã được sử dụng.
