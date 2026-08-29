# RUNBOOK — Trang /sach (danh sách chờ nhận sách)

Trang sống ở file `sach.html`, chạy tại `https://www.ecomgreenway.com/sach`.
Sửa file → commit → push lên `main` → khoảng 1–2 phút sau là live.

---

## 0. TRƯỚC KHI CHẠY THẬT — việc bắt buộc

Trang đang có dòng `<meta name="robots" content="noindex" />` trong phần `<head>`,
chặn Google lập chỉ mục vì nội dung còn là chữ mẫu.

**Điền xong hết chữ thì phải xoá dòng đó**, nếu không trang sẽ mãi không lên Google.
Dòng này có ghi chú cảnh báo ngay phía trên, không thể nhầm.

Việc này không ảnh hưởng traffic từ Facebook — link dán dưới bài vẫn chạy bình thường
kể cả khi còn `noindex`.

---

## 1. Sửa chữ trên trang

Mở `sach.html`. Mọi chỗ cần điền đều bọc trong `[[ ]]` và hiện **nền vàng viền đứt**
trên trình duyệt, không thể bỏ sót. Ngay phía trên mỗi chỗ có dòng ghi chú nói rõ
yêu cầu (bao nhiêu từ, nói gì, tránh gì).

Cách sửa — ví dụ tiêu đề:

```
TRƯỚC:  <h1><span class="ph">[[TIÊU ĐỀ]]</span></h1>
SAU:    <h1>Doanh số tăng đều mà cuối tháng vẫn không thấy lãi</h1>
```

Xoá cả cặp `<span class="ph">` … `</span>`, không chỉ xoá chữ bên trong.

Còn 6 chỗ chưa điền trong thân trang: tiêu đề, dòng dẫn, 3 đoạn mô tả sách, câu cam kết
không spam. Thêm 2 chỗ trong phần `<head>`: `<title>` và `og:title` / `og:description` —
đây là chữ Facebook hiện ra khi dán link, đừng quên.

**Không sửa** khối authority (phần giới thiệu anh Bình) một mình — nội dung đó lấy nguyên
văn từ trang chủ. Sửa ở đây mà không sửa `index.html` là hai trang nói vênh nhau.

---

## 2. Ảnh bìa Facebook

Ảnh hiện tại: `assets/og-sach.png` (1200×630) — thứ người ta nhìn thấy khi anh dán link
xuống dưới bài viết. Nó **không phải file ảnh sửa tay**, mà được vẽ ra từ một trang HTML.

Muốn đổi chữ trên ảnh:

1. Mở `tools/og-sach.html`, sửa 2 chỗ `[[DÒNG DẪN]]` và `[[TIÊU ĐỀ]]`
2. Chạy: `powershell -File tools\render-og.ps1`
3. Ảnh `assets/og-sach.png` tự cập nhật, đúng 1200×630

Tiêu đề trên ảnh nên **trùng với tiêu đề trên trang** — người ta thấy ảnh, bấm vào, thấy
lại đúng câu đó thì mới thấy nhất quán. Muốn tô vàng một cụm thì bọc `<em>…</em>` quanh cụm
đó, chỉ tô một cụm, đừng tô cả câu.

Sau khi đổi ảnh, Facebook vẫn nhớ ảnh cũ. Vào
`developers.facebook.com/tools/debug/`, dán link `https://www.ecomgreenway.com/sach`,
bấm **Scrape Again** để Facebook lấy ảnh mới.

---

## 3. Đổi / cập nhật form Brevo

Khi Brevo cấp mã embed mới, **không dán đè cả khối**. Trong `sach.html` chỉ thay đúng 2 thứ:

- Đường dẫn trong `<form ... action="https://56bfd3ab.sibforms.com/serve/...">`
- Các dòng `name="..."` nếu Brevo đổi tên trường

Giữ nguyên phần CSS ghi đè (khối `FORM BREVO — GHI ĐÈ VỀ DESIGN SYSTEM EGW` trong `<style>`),
nếu không form sẽ quay về màu xanh dương và font Helvetica mặc định của Brevo.

Ba chỗ trên trang **cố ý khác với mã Brevo**, đừng "sửa lại cho giống":

| Chỗ | Brevo sinh ra | Trên trang | Vì sao |
|---|---|---|---|
| Tiêu đề + câu "Ưu đãi 100 người đầu tiên" | nằm trong form | đưa ra ngoài form | để dùng đúng font EGW. Sửa 2 câu này trong `sach.html`, **sửa trong Brevo sẽ không có tác dụng** |
| `NGUON_BAI` | ô nhập chữ nhìn thấy được | `type="hidden"` | khách không cần điền, JS tự đổ số bài vào |
| reCAPTCHA | `?hl=en` | `?hl=vi` | captcha tiếng Việt cho khớp trang |

---

## 4. Xem lead đến từ bài số mấy

Brevo → Contacts. Cột `NGUON_BAI` chính là số bài viết Facebook người đó bấm vào.
Lọc theo cột này để biết bài nào kéo được nhiều đăng ký nhất.

Link đặt dưới mỗi bài phải có dạng — đổi số cuối theo số thứ tự bài:

```
https://www.ecomgreenway.com/sach?bai=15
```

Dán thiếu `?bai=…` thì lead vẫn về bình thường, chỉ là cột `NGUON_BAI` trống, không biết
đến từ bài nào. Viết `/sach/?bai=15` (thừa dấu gạch chéo) sẽ ra **trang 404** — GitHub Pages
không chấp nhận dấu gạch chéo cuối.

---

## 5. Ba lỗi hay gặp nhất

**Lỗi 1 — Đăng ký xong mà cột NGUON_BAI trống.**
Gần như luôn là do link dán dưới bài Facebook thiếu `?bai=…`.
Cách kiểm tra: mở `https://www.ecomgreenway.com/sach?bai=15`, bấm chuột phải → Inspect →
tab Console. Có dòng chữ đỏ "Khong tim thay hidden field NGUON_BAI" nghĩa là ô ẩn trong form
đã bị xoá mất — tìm lại dòng `<input type="hidden" id="NGUON_BAI" ...>` trong `sach.html`.
Không có dòng đỏ nào mà cột vẫn trống thì kiểm tra attribute `NGUON_BAI` bên Brevo còn không.

**Lỗi 2 — Bấm gửi nhưng báo lỗi, không đăng ký được.**
Thường là do captcha. Trang có khối reCAPTCHA vì anh đã bật captcha trong Brevo — hai bên
phải khớp nhau. Nếu **tắt captcha trong Brevo** thì phải xoá cả khối `sib-captcha` và dòng
`recaptcha/api.js` trong `sach.html`; ngược lại, bật lại captcha bên Brevo mà trang không có
khối đó thì mọi lần gửi đều bị từ chối.

**Lỗi 3 — Form hiện ra xấu: chữ Helvetica, nút xám, nền xám.**
CSS của Brevo tải được nhưng phần ghi đè của mình bị xoá hoặc bị đẩy lên trên. Thứ tự bắt
buộc trong `<head>`: dòng `sib-styles.css` phải nằm **TRƯỚC** thẻ `<style>`. Đảo ngược là hỏng.

---

## 6. Những chỗ cố ý làm khác trang chủ

- **Không có nút VI/EN.** Trang chủ ẩn/hiện chữ theo ngôn ngữ đã chọn. Nếu thêm cơ chế đó vào
  đây, người dùng từng bấm EN ở trang chủ sẽ mở /sach ra thấy **trang trắng**.
- **Header chỉ có logo + một link về trang chủ**, không menu, không nút đặt lịch tư vấn.
  Cố ý: trang này chỉ có một việc là lấy đăng ký.
- **Trang chủ không có link trỏ tới /sach.** Cố ý.
- **Ô nhập để cỡ chữ 16px.** Nhỏ hơn thì iPhone tự phóng to trang khi khách bấm vào ô.
- **Captcha bị thu nhỏ trên màn hình hẹp.** Ô captcha của Google rộng cố định 304px, để
  nguyên thì tràn ra ngoài màn 375px và kéo cả trang trượt ngang.
