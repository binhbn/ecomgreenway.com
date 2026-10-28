# RUNBOOK — Trang /chuyen-gia (thư mời đồng hành chuyên gia 1:1)

Trang sống ở file `chuyen-gia.html`, chạy tại `https://www.ecomgreenway.com/chuyen-gia`.
Đường dẫn con, không phải subdomain, vì GitHub Pages chỉ cho một tên miền riêng cho mỗi repo.

---

## 0. Nguồn sự thật KHÔNG nằm ở đây

File `chuyen-gia.html` trong repo này là **bản dựng tự động**. Đừng sửa tay, lần build sau sẽ ghi đè.

Nguồn: `D:\Coaching\coaching-repo\CHUONG-TRINH\ca-0\06-thu-moi-chuyen-gia-v0.2.html`
(file viết cho Artifact: không có `<!DOCTYPE>`/`<html>`/`<head>`, bắt đầu bằng `<title>`).
Bản chữ song song để đọc: `06-thu-moi-chuyen-gia-v0.2.md` cùng thư mục, có nhật ký từng lượt sửa ở đầu file.

## 1. Sửa chữ hay hình → quy trình 6 bước

1. Sửa ở file nguồn bên coaching-repo (sửa chữ thì sửa cả `.md` để hai bản không vênh).
2. Chạy cổng: `python -X utf8 ~/.claude/skills/_shared/lib/report_check.py <file nguồn>` → phải PASS 6/6.
   Trần **350 tiếng mỗi tab**; trang đang ở 335–348. **Muốn thêm chữ thì bớt chữ khác trước.**
3. Critic ở agent riêng (skill `egw-critic`), ghi `06-thu-moi-chuyen-gia-v0.2.critic.md` với đúng một dòng
   `Verdict: ĐẠT`. File critic phải MỚI HƠN file HTML, không thì hook publish Artifact chặn.
4. Dựng bản site: `python -X utf8 tools\build-chuyen-gia.py` (chạy từ thư mục `ecomgreenway.com`).
5. `git add chuyen-gia.html` → commit → push `main`. Khoảng 1–2 phút sau là live. Kiểm:
   `curl -s https://www.ecomgreenway.com/chuyen-gia | grep -c "<chuỗi vừa sửa>"`.
6. Publish lại Artifact cùng link (bản xem trên điện thoại anh Bình vẫn dùng):
   https://claude.ai/artifact/2vi6dbWLonMap7BZo3ECAE

## 2. Ảnh bìa khi dán link lên Facebook / Zalo

Ảnh: `assets/og-chuyen-gia.png` (1200×630). Mẫu vẽ: `tools/og-chuyen-gia.html`.
Đổi chữ trên ảnh → sửa `<h1>` trong mẫu → chạy `powershell -File tools\render-og-chuyen-gia.ps1`.
Đổi tiêu đề trang thì sửa cả `<title>`, `og:title`, `og:description` ở đầu file nguồn cho khớp.
Facebook giữ ảnh cũ trong bộ đệm: dán link vào công cụ Sharing Debugger một lần rồi mới chia sẻ.

## 3. Những thứ cố ý, đừng "sửa cho đẹp"

- **Nút vàng chỉ có một** trong mỗi khung hình (luật EGW-DESIGN): nút "Đặt lịch 60 phút" ở thanh bên.
  Dải CTA cuối mỗi tab dùng nút xanh đậm; nút "Xem một trang" khi bật chuyển nền trắng. Đừng đổi sang vàng.
- **Hình minh hoạ là SVG nét vẽ inline, không có chữ bên trong SVG.** Chữ nằm ở HTML bên cạnh để cổng
  đếm chữ và cổng tràn chữ SVG làm việc đúng. Thêm hình mới thì giữ nguyên tắc này.
- Mọi nút đặt lịch trỏ về `https://cal.com/buingocbinh/60min`. Đổi link thì tìm-thay cả file nguồn (6 chỗ).
- Trang không ghi phí, không ghi tỷ lệ chia doanh thu, không nêu tên thầy nào. Đó là quyết định định vị
  (xem memory coaching-repo `dinh-vi-so-voi-legacy-thay-cong`), không phải thiếu sót.
- Điều khoản hoàn phí ở tab 5 ghi "3 người đầu tiên". Nhãn cùng tên trên thanh tiêu đề đã gỡ 29/10.
  Khi anh Bình mở điều khoản cho mọi người thì đổi chữ ở tab 5, không đổi ở đâu khác.

## 4. Kiểm bằng mắt trước khi push

Ảnh điện thoại 400px: report_check tự chụp, ra file `.m400.png` cạnh file nguồn.
Ảnh cả trang trên máy tính (mọi tab mở): tạo bản tạm đổi `class="shell"` thành `class="shell all"`, rồi
`python ~/.claude/skills/egw-report-ui/scripts/mobile_shot.py <bản tạm> --width 1280 --height 7000 --out desk.png`.
Ảnh cao quá thì cắt từng khúc 1000px bằng PIL rồi mới xem.
