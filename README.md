# Hermes Custom Skills / 定制技能备份

备份我修改过的 Hermes Agent 技能文件，防止被 `hermes skills update` 或版本升级覆盖。

## 技能列表

| 技能 | 说明 | 版本 | 改动 |
|------|------|------|------|
| ocr-and-documents | PDF/DOCX/XLSX 全流程（读/创/编/验） | v3.0 | 从内置 built-in 大幅升级 |

## 升级内容（vs 原版）

- **DOCX**: 新增 docx-js 创建、python-docx 编辑、pandoc 格式转换、交叉引用检测
- **XLSX**: 新增 openpyxl 创建/编辑、pandas 数据分析、工程颜色规范、5 步验证流程
- **PDF**: 新增 pypdf 表单/水印/加密、pdfplumber 表格提取

对标 Anthropic 官方 skills，并在验证流程上超越。

## 恢复方法

```bash
# 覆盖 Hermes 内置版本
cp ocr-and-documents.md ~/AppData/Local/hermes/skills/productivity/ocr-and-documents/SKILL.md
```
