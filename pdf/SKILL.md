---
name: pdf
description: "Create, read, edit, or manipulate PDF files. Triggers: PDF, .pdf, merge, split, extract text, extract tables, rotate, watermark, encrypt, decrypt, fill forms, OCR."
version: "3.0.0"
metadata:
  hermes:
    tags: [pdf, documents, ocr, forms, extraction]
    source: "https://github.com/anthropics/skills"
    adapted_for: "hermes-agent"
---

# PDF Processing Guide

Runs in Docker sandbox. pypdf 6.13, pdfplumber 0.11, pymupdf 1.27, Poppler 25.03 all pre-installed.

**Load:** `/skill pdf`