# -*- coding: utf-8 -*-
"""Dựng chuyen-gia.html (trang /chuyen-gia) từ file nguồn trong repo coaching.

Nguồn sự thật: D:\\Coaching\\coaching-repo\\CHUONG-TRINH\\ca-0\\06-thu-moi-chuyen-gia-v0.2.html
(file này viết cho Artifact, không có <!DOCTYPE>/<html>/<head>, bắt đầu bằng <title>).
Script bọc nó thành một trang HTML đầy đủ cho GitHub Pages, thêm charset, viewport, favicon.

Chạy:  python -X utf8 tools\\build-chuyen-gia.py
Sửa chữ trang → sửa ở file nguồn bên coaching-repo (qua report_check + critic), rồi chạy lại script này.
Đừng sửa chuyen-gia.html bằng tay, lần build sau sẽ ghi đè.
"""
import io, os, sys

SRC = r'D:\Coaching\coaching-repo\CHUONG-TRINH\ca-0\06-thu-moi-chuyen-gia-v0.2.html'
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(REPO, 'chuyen-gia.html')

s = io.open(SRC, encoding='utf-8').read()
if not s.lstrip().startswith('<title>'):
    sys.exit('Nguồn không bắt đầu bằng <title>, cấu trúc đã đổi, kiểm lại script.')
marker = '</style>\n'
i = s.find(marker)
if i < 0:
    sys.exit('Không thấy </style> trong nguồn.')
head_part = s[:i + len(marker)]
body_part = s[i + len(marker):]

doc = (
    '<!DOCTYPE html>\n'
    '<!-- /chuyen-gia: dựng tự động từ coaching-repo bằng tools/build-chuyen-gia.py. ĐỪNG SỬA TAY. -->\n'
    '<html lang="vi">\n<head>\n'
    '<meta charset="UTF-8">\n'
    '<meta name="viewport" content="width=device-width, initial-scale=1.0">\n'
    '<link rel="icon" type="image/jpeg" href="assets/ECom GreenWay favicon.jpeg">\n'
    + head_part +
    '</head>\n<body>\n'
    + body_part.rstrip('\n') +
    '\n</body>\n</html>\n'
)
io.open(OUT, 'w', encoding='utf-8', newline='\n').write(doc)
print('OK ->', OUT, len(doc), 'bytes')
