# Chup tools/og-sach.html thanh anh assets/og-sach.png dung 1200x630.
# Chay:  powershell -File tools\render-og.ps1
# Can: Chrome hoac Edge (may Windows nao cung co san Edge).
#
# LUU Y: file nay phai giu nguyen dang khong dau. Windows PowerShell 5.1
# doc file theo bang ma cu, co dau tieng Viet la loi cu phap ngay.

$ErrorActionPreference = 'Stop'

$repo = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $repo 'tools\og-sach.html'
$out  = Join-Path $repo 'assets\og-sach.png'

if (-not (Test-Path $src)) { throw "Khong thay file $src" }

$trinhDuyet = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $trinhDuyet) { throw "Khong tim thay Chrome hoac Edge de chup anh." }

if (Test-Path $out) { Remove-Item $out -Force }

# Duong dan repo co dau cach ("EGW - Landingpage") nen phai doi thanh %20,
# neu khong Chrome coi la nhieu tham so va khong chup gi ca.
$duongDan = 'file:///' + (($src -replace '\\','/') -replace ' ','%20')

# Truyen tham so qua MANG, khong viet thang tren dong lenh: duong dan output
# co dau cach, viet thang thi PowerShell 5.1 cat lam doi va Chrome khong chup.
#
# virtual-time-budget: doi font Google tai xong roi moi chup.
# Bo dong nay thi anh ra font he thong, sai brand.
$thamSo = @(
  '--headless',
  '--disable-gpu',
  '--hide-scrollbars',
  '--window-size=1200,630',
  "--screenshot=$out",
  '--virtual-time-budget=6000',
  $duongDan
)
# Goi bang & voi mang tham so. KHONG dung Start-Process -ArgumentList:
# PowerShell 5.1 noi mang bang dau cach ma khong dat trong ngoac, nen duong dan
# co dau cach bi cat doi va Chrome khong chup gi.
& $trinhDuyet $thamSo

# Chrome tach tien trinh con de ghi file, nen -Wait van co the tra ve truoc khi
# anh ghi xong. Doi toi da 20 giay va doi ca luc kich thuoc file dung yen.
$kichCu = -1
for ($i = 0; $i -lt 40; $i++) {
  if (Test-Path $out) {
    $kichMoi = (Get-Item $out).Length
    if ($kichMoi -gt 0 -and $kichMoi -eq $kichCu) { break }
    $kichCu = $kichMoi
  }
  Start-Sleep -Milliseconds 500
}

if (-not (Test-Path $out)) { throw "Chup that bai, khong tao duoc $out" }

Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile($out)
$kichThuoc = "$($img.Width)x$($img.Height)"
$img.Dispose()

if ($kichThuoc -ne '1200x630') {
  Write-Host "CANH BAO: anh ra $kichThuoc, khong phai 1200x630." -ForegroundColor Red
  exit 1
}

Write-Host "Xong: assets\og-sach.png ($kichThuoc)" -ForegroundColor Green
