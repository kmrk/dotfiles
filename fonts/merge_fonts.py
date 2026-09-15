#!/usr/bin/env python3
from pathlib import Path

from fontTools.merge import Merger
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTFont, newTable
from fontTools.ttLib.scaleUpem import scale_upem

WORKDIR = Path(__file__).resolve().parent
MONASPACE = WORKDIR / "MonaspaceNeon-Regular.otf"
MONASPACE_TTF = WORKDIR / "MonaspaceNeon-Regular.ttf"
CHINESE_TTC = Path("/usr/share/fonts/truetype/wqy/wqy-microhei.ttc")
CHINESE_FONT = WORKDIR / "WenQuanYiMicroHeiMono-Regular.ttf"
OUTPUT = WORKDIR / "MonaspaceNeonWQYMono-Regular.ttf"

CHINESE_FONT_INDEX = 1
FAMILY_NAME = "Monaspace Neon WQY Mono"
STYLE_NAME = "Regular"
FULL_NAME = f"{FAMILY_NAME} {STYLE_NAME}"
POSTSCRIPT_NAME = "MonaspaceNeonWQYMono-Regular"


def export_ttc_face(ttc_path: Path, font_number: int, output_path: Path) -> None:
    font = TTFont(ttc_path, fontNumber=font_number)
    scale_upem(font, 2000)
    for tag in ("vhea", "vmtx", "VORG", "fpgm", "prep", "cvt ", "FFTM"):
        if tag in font:
            del font[tag]
    font.save(output_path)


def convert_otf_to_ttf(input_path: Path, output_path: Path) -> None:
    font = TTFont(input_path)
    glyph_set = font.getGlyphSet()
    glyph_order = font.getGlyphOrder()

    glyf = newTable("glyf")
    glyf.glyphs = {}
    glyf.glyphOrder = glyph_order

    for glyph_name in glyph_order:
        pen = TTGlyphPen(glyph_set)
        quad_pen = Cu2QuPen(pen, max_err=1.0, reverse_direction=True)
        glyph_set[glyph_name].draw(quad_pen)
        glyf.glyphs[glyph_name] = pen.glyph()

    font["glyf"] = glyf
    font["loca"] = newTable("loca")
    if "CFF " in font:
        del font["CFF "]
    if "VORG" in font:
        del font["VORG"]

    font.sfntVersion = "\x00\x01\x00\x00"
    font["maxp"].tableVersion = 0x00010000
    font["maxp"].maxZones = 1
    font["maxp"].maxTwilightPoints = 0
    font["maxp"].maxStorage = 0
    font["maxp"].maxFunctionDefs = 0
    font["maxp"].maxInstructionDefs = 0
    font["maxp"].maxStackElements = 0
    font["maxp"].maxSizeOfInstructions = 0
    font["post"].formatType = 3.0
    font.save(output_path)


def set_font_names(font: TTFont) -> None:
    name_table = font["name"]
    replacements = {
        1: FAMILY_NAME,
        2: STYLE_NAME,
        4: FULL_NAME,
        6: POSTSCRIPT_NAME,
        16: FAMILY_NAME,
        17: STYLE_NAME,
    }
    for record in name_table.names:
        if record.nameID in replacements:
            record.string = replacements[record.nameID].encode(record.getEncoding())


def main() -> None:
    convert_otf_to_ttf(MONASPACE, MONASPACE_TTF)
    export_ttc_face(CHINESE_TTC, CHINESE_FONT_INDEX, CHINESE_FONT)

    merger = Merger()
    merged = merger.merge([str(MONASPACE_TTF), str(CHINESE_FONT)])
    set_font_names(merged)
    merged.save(OUTPUT)

    print(f"Created {OUTPUT.name}")


if __name__ == "__main__":
    main()
