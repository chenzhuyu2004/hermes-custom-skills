# Hermes Custom Skills

我的 Hermes Agent 定制技能备份 / My customized Hermes Agent skills backup.

## 安装 / Install

```bash
# 添加技能源
hermes skills tap add chenzhuyu2004/hermes-custom-skills

# 安装所有技能
hermes skills install deep-research --category academic-research
hermes skills install academic-paper --category academic-research
hermes skills install academic-paper-reviewer --category academic-research
hermes skills install academic-pipeline --category academic-research
```

## 技能列表 / Skills

### academic-research 系列（改编自 [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills)）

| 技能 | 版本 | Agent | 模式 | 用途 |
|------|------|-------|------|------|
| `deep-research` | 2.9.4 | 13 | 7 | 深度学术研究（系统综述/元分析/苏格拉底引导） |
| `academic-paper` | 3.2.0 | 12 | 10 | 论文写作（中英双语/LaTeX/DOCX/PDF） |
| `academic-paper-reviewer` | 1.10.0 | 7 | 6 | 多视角同行审稿（EIC+3审稿人+魔鬼代言人） |
| `academic-pipeline` | 3.12.0 | 5 | 10阶段 | 全流程编排（研究→写作→审查→修改→定稿） |

### 其他技能

| 技能 | 用途 |
|------|------|
| `ocr-and-documents` | OCR 识别 + PDF/DOCX/XLSX 文档处理 |

## 共享资源 / Shared

`shared/` 目录包含跨技能共享的协议、契约、模板和参考文件。
