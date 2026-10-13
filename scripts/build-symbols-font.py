#!/usr/bin/env python3
"""Build a local sbix font from the licensed Symbols SVG snapshot.

Requires fonttools, resvg-py and pillow. No network or VSCode dependency.
Colored bitmap strikes preserve SVG drawings; outlines supply a monochrome
fallback when a font renderer does not support sbix. Text uses its existing font.
"""
import argparse
import io
import json
from pathlib import Path

import resvg_py
from PIL import Image
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import newTable
from fontTools.ttLib.tables.sbixGlyph import Glyph
from fontTools.ttLib.tables.sbixStrike import Strike


def render(source, pixels):
    png = resvg_py.svg_to_bytes(svg_string=source.decode('utf-8'), width=pixels, height=pixels, skip_system_fonts=True)
    image = Image.open(io.BytesIO(png)).convert('RGBA')
    canvas = Image.new('RGBA', (pixels, pixels))
    canvas.alpha_composite(image, ((pixels-image.width)//2, (pixels-image.height)//2))
    result = io.BytesIO()
    canvas.save(result, format='PNG')
    return result.getvalue()


def outline(png):
    """Trace the alpha silhouette on a 64px grid, retaining transparent holes."""
    image = Image.open(io.BytesIO(png)).convert('RGBA')
    size = image.width
    alpha = image.getchannel('A')
    pixels = {(x, y) for y in range(size) for x in range(size) if alpha.getpixel((x, y)) >= 96}
    edges = {}
    for x, y in sorted(pixels):
        for neighbor, a, b in (
            ((x, y-1), (x, y), (x+1, y)),
            ((x+1, y), (x+1, y), (x+1, y+1)),
            ((x, y+1), (x+1, y+1), (x, y+1)),
            ((x-1, y), (x, y+1), (x, y)),
        ):
            if neighbor not in pixels:
                edges.setdefault(a, []).append(b)
    pen = TTGlyphPen(None)
    while edges:
        start = next(iter(edges))
        point = start
        pen.moveTo((round(point[0]*800/size), round(40+(size-point[1])*800/size)))
        while True:
            choices = edges[point]
            next_point = choices.pop()
            if not choices:
                del edges[point]
            if next_point == start:
                break
            pen.lineTo((round(next_point[0]*800/size), round(40+(size-next_point[1])*800/size)))
            point = next_point
        pen.closePath()
    return pen.glyph()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    config = Path(__file__).resolve().parents[1]
    data = json.loads((config/'data/symbols-icons.json').read_text())
    catalog = data['catalog']
    names = ['.notdef'] + list(sorted(catalog))
    font = FontBuilder(1000, isTTF=True)
    font.setupGlyphOrder(names)
    font.setupCharacterMap({entry['codepoint']: name for name, entry in catalog.items()})
    glyphs = {'.notdef': TTGlyphPen(None).glyph()}
    sbix = newTable('sbix')
    sbix.version, sbix.flags, sbix.strikes = 1, 1, {}
    for size in (16, 20, 24, 28, 32, 40, 48, 64, 96):
        sbix.strikes[size] = Strike(ppem=size, resolution=72)
    for name, entry in sorted(catalog.items()):
        svg = (config/entry['svg']).resolve()
        if not svg.is_relative_to(config/'data/symbols-svg'):
            raise ValueError('SVG must be inside the licensed snapshot')
        source = svg.read_bytes()
        # Center rectangular canvases without distorting their aspect ratio.
        png = render(source, 64)
        glyphs[name] = outline(png)
        for size, strike in sbix.strikes.items():
            pixels = round(size*.8)
            png = render(source, pixels)
            strike.glyphs[name] = Glyph(
                glyphName=name, originOffsetX=0, originOffsetY=round(size*.04),
                graphicType='png ', imageData=png,
            )
    font.setupGlyf(glyphs)
    font.setupHorizontalMetrics({name: (600, 0) for name in names})
    font.setupHorizontalHeader(ascent=1020, descent=-300)
    font.setupNameTable({
        'familyName': 'Neovim Symbols', 'styleName': 'Regular',
        'uniqueFontIdentifier': 'Neovim Symbols '+data['version'],
        'fullName': 'Neovim Symbols Regular', 'psName': 'NeovimSymbols-Regular',
        'version': 'Version '+data['version'],
        'copyright': 'Symbols SVGs: Copyright (c) 2020-2022 Miguel Solorio; MIT license.',
        'licenseDescription': (config/'licenses/symbols-MIT.txt').read_text(),
    })
    font.setupOS2(sTypoAscender=1020, sTypoDescender=-300, usWinAscent=1020, usWinDescent=300)
    font.setupPost(isFixedPitch=1)
    font.font['sbix'] = sbix
    args.output.parent.mkdir(parents=True, exist_ok=True)
    font.save(args.output)
    args.output.with_suffix('.json').write_text(json.dumps({'signature': data['font_signature'], 'icons': len(catalog), 'renderer': 'resvg-sbix-v1'})+'\n')
    print(f'PASS: {len(catalog)} SVG icons, {len(sbix.strikes)} color strikes: {args.output}')


if __name__ == '__main__':
    main()
