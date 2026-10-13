"""Validate the installed font against its source catalog and the text font."""
import io
import json
import os
import subprocess
from pathlib import Path

from PIL import Image
from fontTools.ttLib import TTFont

config = Path(__file__).resolve().parents[1]
data = json.loads((config/'data/symbols-icons.json').read_text())
path = Path(os.environ.get('XDG_DATA_HOME', str(Path.home()/'.local/share')))/'fonts/nvim-symbols/NeovimSymbols-Regular.ttf'
font = TTFont(path)
metadata = json.loads(path.with_suffix('.json').read_text())
assert metadata['signature'] == data['font_signature']
assert metadata['renderer'] == 'resvg-sbix-v2'
expected = {entry['codepoint']: name for name, entry in data['catalog'].items()}
assert font.getBestCmap() == expected, 'Font must contain exactly the catalog codepoints'
text = TTFont(subprocess.check_output(['fc-match','-f','%{file}','JetBrainsMono Nerd Font']).decode())
assert not (expected.keys() & text.getBestCmap().keys()), 'Symbols must not override text or Nerd Font glyphs'
images = 0
for codepoint, name in expected.items():
    assert font['glyf'][name].numberOfContours > 0, name+' has no monochrome outline'
    for size, strike in font['sbix'].strikes.items():
        image = Image.open(io.BytesIO(strike.glyphs[name].imageData)).convert('RGBA')
        assert image.width == image.height == size, name+' has inconsistent bitmap dimensions'
        assert image.getchannel('A').getbbox(), name+' is invisible'
        images += 1
assets = Image.open(io.BytesIO(font['sbix'].strikes[64].glyphs['folder-assets'].imageData)).convert('RGBA')
assert len({rgba[:3] for rgba in assets.get_flattened_data() if rgba[3]==255}) >= 4, 'Folder badge colors lost'
# SVG luminance masks define the Svelte negative space. An alpha-only renderer
# incorrectly fills it; test a pixel well inside the cutout at this resolution.
svelte = Image.open(io.BytesIO(font['sbix'].strikes[96].glyphs['svelte'].imageData)).convert('RGBA')
assert svelte.getpixel((48, 48))[3] < 30, 'Svelte SVG mask lost its central negative space'
print(f'PASS: {len(expected)} glyphs, {images} colored bitmaps, folder badge colors and SVG mask; no text-font collisions')
