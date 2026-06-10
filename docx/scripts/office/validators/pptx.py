"""
PPTX validator — stub for docx-only installations.

The official Anthropic skills repo shares validators between docx/pptx/xlsx skills.
This stub allows the docx skill to work standalone without the pptx validator.
"""

class PPTXSchemaValidator:
    """Stub — PPTX validation is not included in the docx skill."""
    def __init__(self, *args, **kwargs):
        pass
    def validate(self):
        return True
    def repair(self):
        return 0
