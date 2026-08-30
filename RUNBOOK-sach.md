# RUNBOOK — Trang /sach (danh sách chờ nhận sách)

Trang sống ở file `sach.html`, chạy tại `https://www.ecomgreenway.com/sach`.
Sửa file → commit → push lên `main` → khoảng 1–2 phút sau là live.

---

## 0. Trang đang ở bản v1 rút gọn

Cấu trúc hiện tại, từ trên xuống: header → tiêu đề → khối uy tín → form → footer.
Phần mô tả sách **chưa có**, đây là quyết định có chủ ý để deploy sớm.

Trang có dòng `<meta name="robots" content="noindex" />` trong `<head>`, chặn Google
lập chỉ mục. **Bổ sung xong phần mô tả sách thì xoá dòng đó** — nếu không trang sẽ mãi
không lên Google. Dòng này có ghi chú cảnh báo ngay phía trên, không thể nhầm.

Việc này không ảnh hưởng traffic từ Facebook — link dán dưới bài vẫn chạy bình thường
kể cả khi còn `noindex`.

---

## 1. Bổ sung chữ vào trang

Mở `sach.html` và tìm các comment bắt đầu bằng **`CHỖ DÀNH CHO`** — mỗi comment nằm
đúng vị trí sẽ điền, kèm sẵn đoạn mã mẫu và yêu cầu (bao nhiêu từ, nói gì, tránh gì).

Có 4 chỗ đang để trống:

| Chỗ | Nằm ở đâu | Nội dung cần |
|---|---|---|
| Dòng dẫn trên tiêu đề | trong khối `hero` | ≤ 8 từ, in hoa, nói đây là cái gì |
| Mô tả sách (3 đoạn) | giữa tiêu đề và khối uy tín | vấn đề người đọc gặp → sách giải quyết ra sao → viết cho ai |
| Tiêu đề khối form | trong `form-card` | ≤ 10 từ, nói người đọc nhận được gì |
| Câu cam kết không spam | ngay trước link Chính sách bảo mật | 1 câu ngắn |

CSS cho các khối này **vẫn còn nguyên** trong thẻ `<style>`, không cần viết lại — chỉ
cần bỏ dấu chú thích quanh đoạn mã mẫu và thay chữ.

Sửa tiêu đề chính thì nhớ sửa cả `<title>`, `og:title` và ảnh bìa (mục 2) cho khớp nhau.

**Không sửa** khối authority (phần giới thiệu anh Bình) một mình — nội dung đó lấy nguyên
văn từ trang chủ. Sửa ở đây mà không sửa `index.html` là hai trang nói vênh nhau.

---

## 2. Ảnh bìa Facebook

Ảnh hiện tại: `assets/og-sach.png` (1200×630) — thứ người ta nhìn thấy khi anh dán link
xuống dưới bài viết. Nó **không phải file ảnh sửa tay**, mà được vẽ ra từ một trang HTML.

Muốn đổi chữ trên ảnh:

1. Mở `tools/og-sach.html`, sửa dòng `<h1>` (và thêm dòng dẫn nếu muốn)
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
| Tiêu đề + câu "Ưu đãi 100 người đầu tiên" | nằm trong form | **đã gỡ hẳn** | tiêu đề đã lên làm `<h1>` đầu trang, để trong form nữa là lặp hai lần trên một màn hình |
| Thụt lề nhóm lựa chọn | `padding-left:1.5em; text-indent:-1.5em` | huỷ cả hai | `text-indent` âm kéo riêng dòng đầu lùi ngược, đè lên nút tròn và ăn mất ký tự đầu ("hưa từng" thay vì "Chưa từng") |
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
- **Nhóm lựa chọn bị huỷ thụt lề của Brevo.** Xem bảng ở mục 3 — bỏ phần huỷ đó là ký tự
  đầu mỗi dòng bị nút tròn che mất.
