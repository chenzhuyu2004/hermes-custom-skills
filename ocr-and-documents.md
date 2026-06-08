---
name: ocr-and-documents
description: "Read, create, and edit PDFs, DOCX, and XLSX files. Extraction, creation, editing, form-filling, and verification workflows."
version: 3.0.0
author: Hermes Agent (upgraded with Anthropic parity)
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [PDF, DOCX, XLSX, Documents, Research, Text-Extraction, Creation, Editing]
    related_skills: [powerpoint]
---

# PDF, DOCX & XLSX — 读取/创建/编辑 全流程

## 依赖一览

| 工具 | 用途 | 安装 |
|------|------|------|
| python-docx | DOCX 读取/编辑 | `pip install python-docx` ✓ |
| docx-js | DOCX 创建（JS） | `npm install -g docx` ✓ |
| pandoc | DOCX 格式转换/修订 | winget pandoc ✓ |
| openpyxl | XLSX 读取/创建/编辑 | `pip install openpyxl` ✓ |
| pypdf | PDF 拆分/合并/表单/水印 | `pip install pypdf` ✓ |
| pymupdf | PDF 提取/OCR | `pip install pymupdf` ✓ |
| marker-pdf | 扫描件 OCR | `pip install marker-pdf`（按需） |

当前环境: `python`=3.11（openpyxl/pypdf/python-docx/pymupdf/pdfplumber/pandas），NODE_PATH 指向全局 node_modules，pandoc 在 PATH。

---

# 📄 DOCX

## 读取与分析

```python
from docx import Document
doc = Document('file.docx')
# 段落
for p in doc.paragraphs:
    if p.text.strip():
        print(f'[{p.style.name}] {p.text}')
# 表格
for i, t in enumerate(doc.tables):
    print(f'\n--- 表格{i+1} ---')
    for row in t.rows:
        print(' | '.join(c.text for c in row.cells))
# 章节结构
for p in doc.paragraphs:
    if p.style.name.startswith('Heading'):
        level = int(p.style.name.split()[-1]) if ' ' in p.style.name else 1
        print(f'{"  "*(level-1)}{p.text}')
```

## 编辑已有文档

```python
from docx import Document
from docx.shared import Pt, Cm, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH

doc = Document('input.docx')

# 替换文字（遍历所有段落）
for p in doc.paragraphs:
    if '旧文字' in p.text:
        for run in p.runs:
            if '旧文字' in run.text:
                run.text = run.text.replace('旧文字', '新文字')

# 在末尾追加段落
doc.add_paragraph('新增内容', style='Normal')

# 在末尾追加表格
table = doc.add_table(rows=3, cols=3)
table.cell(0,0).text = '表头1'

# 修改段落样式
for p in doc.paragraphs:
    if p.style.name.startswith('Heading'):
        for run in p.runs:
            run.font.size = Pt(16)

doc.save('output.docx')
```

## 创建新文档（docx-js）

用于需要专业排版（目录、分页、页眉页脚、信头）的场景：

```javascript
// create_docx.js — 运行: node create_docx.js
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        Header, Footer, AlignmentType, HeadingLevel, PageBreak,
        TableOfContents } = require('docx');
const fs = require('fs');

const doc = new Document({
  styles: { default: { document: { run: { font: "Times New Roman", size: 24 } } } },
  sections: [{
    properties: { page: { margin: { top: 1440, bottom: 1440, left: 1440, right: 1440 } } },
    headers: { default: new Header({ children: [new Paragraph({ alignment: AlignmentType.RIGHT,
      children: [new TextRun("桂林甲山屠宰场冷库系统设计")] })] }) },
    children: [
      new Paragraph({ heading: HeadingLevel.TITLE, children: [new TextRun("文档标题")] }),
      new TableOfContents("目录", { hyperlink: true, headingStyleRange: "1-3" }),
      new Paragraph({ children: [new PageBreak()] }),
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun("第一章")] }),
      new Paragraph({ children: [new TextRun("正文内容...")] }),
    ]
  }]
});

Packer.toBuffer(doc).then(buf => fs.writeFileSync("output.docx", buf));
```

运行：`node create_docx.js`

## 跟踪修订与格式转换

### 格式互转（核心能力）

```bash
# DOCX → Markdown（论文提取）
pandoc 论文.docx -o 论文.md

# DOCX → Markdown（保留修订标记）
pandoc --track-changes=all 论文.docx -o 论文_修订.md

# Markdown → DOCX（裸输出）
pandoc report.md -o report.docx

# Markdown → DOCX（套模板——保留学校格式）
pandoc report.md --reference-doc=template.docx -o report.docx

# DOCX → PDF
pandoc 论文.docx --pdf-engine=xelatex -o 论文.pdf

# 提取嵌入图片
pandoc 论文.docx --extract-media=./images -o 论文.md
```

### 接受全部修订（需 LibreOffice，按需）

```bash
soffice --headless --macro "Standard.Module1.AcceptAllChanges" input.docx
```

## 交叉引用检测

```python
import re
from docx import Document
doc = Document('file.docx')
for i, p in enumerate(doc.paragraphs):
    if '错误!' in p.text or 'Error!' in p.text:
        print(f'[段落{i}] 损坏的交叉引用: {p.text[:100]}')
```

---

# 📊 XLSX

## 读取与分析

### openpyxl（逐单元格读取）

```python
from openpyxl import load_workbook
wb = load_workbook('file.xlsx', data_only=True)
print(f'工作表: {wb.sheetnames}')
for name in wb.sheetnames:
    ws = wb[name]
    print(f'\n--- {name} ({ws.max_row}行 × {ws.max_column}列) ---')
    for row in ws.iter_rows(values_only=True):
        print(' | '.join(str(v) if v is not None else '' for v in row))
```

### pandas（数据分析——Anthropic 同等能力）

pandas 比 openpyxl 裸读强大得多，适合数据处理和分析：

```python
import pandas as pd

# 读取整个文件
xls = pd.ExcelFile('计算.xlsx')
print(f'工作表: {xls.sheet_names}')

# 读单个 sheet
df = pd.read_excel('计算.xlsx', sheet_name='高温系统热力计算')

# 只看关键列
print(df[['参数', '数值', '单位']].head(10))

# 筛选（如：找所有待验证的黄色单元格=空值行）
missing = df[df['数值'].isna()]
print(f'\n待填写行 ({len(missing)}行):')
print(missing)

# 多 sheet 对比（主表 vs 对照表）
main = pd.read_excel('计算.xlsx', sheet_name='高温系统热力计算')
ref = pd.read_excel('计算.xlsx', sheet_name='预期值对照')

# 合并对比
merged = main.merge(ref, on='参数', suffixes=('_主表', '_对照'))
merged['偏差'] = abs(merged['数值_主表'] - merged['数值_对照'])
print(merged[merged['偏差'] > 1])  # 偏差超过1的行

# 导出结果
merged.to_excel('对比结果.xlsx', index=False)
```

## 创建新表格

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, numbers
from openpyxl.utils import get_column_letter

wb = Workbook()
ws = wb.active
ws.title = "制冷负荷计算"

# === 工程规范颜色 ===
FONT_INPUT   = Font(color="0000FF", bold=True)   # 蓝色=输入参数
FONT_FORMULA = Font(color="000000")               # 黑色=公式
FONT_LINK    = Font(color="008000")               # 绿色=跨表引用
FILL_ASSUMP  = PatternFill(start_color="FFFF00", end_color="FFFF00", fill_type="solid")  # 黄色=待验证
FILL_HEADER  = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
FONT_HEADER  = Font(color="FFFFFF", bold=True, size=12)

# 表头
headers = ['参数', '符号', '数值', '单位', '公式/来源']
for col, h in enumerate(headers, 1):
    cell = ws.cell(row=1, column=col, value=h)
    cell.font = FONT_HEADER
    cell.fill = FILL_HEADER

# 数据行示例
data = [
    ['蒸发温度', 't₀', -40, '°C', '设计取值', FONT_INPUT],
    ['冷凝温度', 'tₖ', 38, '°C', '设计取值', FONT_INPUT],
    ['单位质量制冷量', 'q₀', None, 'kJ/kg', '=h1-h4', FONT_FORMULA],
]

for i, (name, sym, val, unit, source, font) in enumerate(data, 2):
    ws.cell(row=i, column=1, value=name).font = font
    ws.cell(row=i, column=2, value=sym).font = font
    ws.cell(row=i, column=3, value=val).font = font
    if val is None:
        ws.cell(row=i, column=3).fill = FILL_ASSUMP
    ws.cell(row=i, column=4, value=unit)
    ws.cell(row=i, column=5, value=source)

# 列宽自适应
for col in range(1, 6):
    ws.column_dimensions[get_column_letter(col)].width = 18

wb.save('制冷计算.xlsx')
```

## 编辑已有表格

```python
from openpyxl import load_workbook
wb = load_workbook('file.xlsx')
ws = wb.active

# 修改单元格
ws['B5'] = 100  # 直接赋值

# 插入公式
ws['D10'] = '=B5*C5'

# 追加行
ws.append(['新增', '数据', '行'])

wb.save('file.xlsx')
```

## ✅ 5 步验证流程（工程计算必做）

```python
from openpyxl import load_workbook
import json

# Step 1: 读计算值
wb_data = load_workbook('file.xlsx', data_only=True)
# Step 2: 读公式
wb_formula = load_workbook('file.xlsx', data_only=False)

# Step 3: 抽检——手动验算 3-5 个关键单元格
check_cells = ['D10', 'E15', 'F20']
for cell_ref in check_cells:
    val = wb_data.active[cell_ref].value
    formula = wb_formula.active[cell_ref].value
    print(f'{cell_ref}: 计算值={val}, 公式={formula}')

# Step 4: 交叉比对（对比论文/规范值）
# 手动列出期望值 → 比较 → 标出偏差 >1% 的

# Step 5: 如果有"对照表"sheet → 对比主表和对照表
if '对照' in wb_data.sheetnames or 'expected' in [s.lower() for s in wb_data.sheetnames]:
    # 对照表是 AI 自己的预期 → 主表不一致说明主表公式有问题
    pass
```

**AI 常见错误速查：**
- 公式引用了原始输入而非中间计算结果 → 应引用计算链中的上一级单元格
- 硬编码数值替代了公式 → 改为公式引用
- 主表与对照表不一致 → 以对照表为准，修正主表公式
- 单位混用（kJ/kg vs kJ, °C vs K）

---

# 📑 PDF

## 读取与提取

### pymupdf（文本提取）

```python
import pymupdf
doc = pymupdf.open('file.pdf')
print(f'页数: {len(doc)}')
for i, page in enumerate(doc):
    text = page.get_text()
    if text.strip():
        print(f'\n--- 第{i+1}页 ---')
        print(text[:500])
```

### pdfplumber（表格提取——精度更高）

pdfplumber 的表格提取远强于 pymupdf，适合毕设论文中的参数表、规范对照表：

```python
import pdfplumber

with pdfplumber.open('file.pdf') as pdf:
    for i, page in enumerate(pdf.pages):
        tables = page.extract_tables()
        if tables:
            print(f'\n=== 第{i+1}页: {len(tables)}个表格 ===')
            for j, table in enumerate(tables):
                print(f'--- 表格{j+1} ---')
                for row in table:
                    print(' | '.join(str(c) if c else '' for c in row))

# 提取所有表格到 CSV
import csv, pdfplumber
with pdfplumber.open('规范.pdf') as pdf:
    all_tables = []
    for page in pdf.pages:
        for table in page.extract_tables():
            all_tables.append(table)

with open('提取的表格.csv', 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    for table in all_tables:
        for row in table:
            writer.writerow(row)
        writer.writerow([])  # 空行分隔

# 提取特定区域（精确裁剪）
cropped = page.crop((0, 100, page.width, 300))  # 裁剪指定区域
print(cropped.extract_text())
```

### 对比：pymupdf vs pdfplumber

| 场景 | 用哪个 |
|------|--------|
| 纯文本提取 | pymupdf（更快） |
| **带边框的表格** | pdfplumber（精度高） |
| 扫描件 OCR | marker-pdf |
| 嵌入式图片 | pymupdf |

## 拆分与合并

```python
# 合并
from pypdf import PdfWriter, PdfReader
writer = PdfWriter()
for f in ['a.pdf', 'b.pdf']:
    writer.append(f)
writer.write('merged.pdf')

# 拆分
reader = PdfReader('input.pdf')
for i in range(len(reader.pages)):
    w = PdfWriter(); w.add_page(reader.pages[i])
    w.write(f'page_{i+1}.pdf')
```

## 旋转与元数据

```python
from pypdf import PdfReader, PdfWriter
reader = PdfReader('input.pdf')
print(f'标题: {reader.metadata.title}')
print(f'作者: {reader.metadata.author}')

# 旋转第一页 90°
writer = PdfWriter()
page = reader.pages[0]; page.rotate(90)
writer.add_page(page)
writer.write('rotated.pdf')
```

## 填写 PDF 表单

```python
from pypdf import PdfReader, PdfWriter

reader = PdfReader('form.pdf')
writer = PdfWriter()
writer.append(reader)

# 获取表单字段
fields = reader.get_form_text_fields()
print(f'可填写字段: {list(fields.keys())}')

# 填写
writer.update_page_form_field_values(writer.pages[0], {
    'Name': '陈竹宇',
    'Date': '2026-06-08',
}, auto_regenerate=False)

with open('filled.pdf', 'wb') as f:
    writer.write(f)
```

## 水印

```python
from pypdf import PdfReader, PdfWriter

watermark = PdfReader('watermark.pdf').pages[0]
reader = PdfReader('doc.pdf')
writer = PdfWriter()

for page in reader.pages:
    page.merge_page(watermark, over=False)  # over=False=背景水印
    writer.add_page(page)

writer.write('watermarked.pdf')
```

## 加密/解密

```python
from pypdf import PdfReader, PdfWriter

reader = PdfReader('input.pdf')
writer = PdfWriter()
writer.append(reader)
writer.encrypt('user123', 'owner456')  # 用户密码, 所有者密码
writer.write('encrypted.pdf')

# 解密
reader = PdfReader('encrypted.pdf')
reader.decrypt('user123')
```

## OCR 扫描件（marker-pdf，按需）

```bash
pip install marker-pdf
marker_single scanned.pdf --output_dir ./output
```

---

## 远程 URL

有 URL 优先用 `web_extract`：
```
web_extract(urls=["https://arxiv.org/pdf/2402.03300"])
```
本地文件才用上述工具。
