#!/usr/bin/env python3
"""Import Symbols associations/colors; SVG shapes are represented by font glyphs."""
import argparse,collections,json,re
from pathlib import Path
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('extension',type=Path,help='Installed miguelsolorio.symbols extension directory')
args=parser.parse_args()
root=args.extension.resolve()
config=Path(__file__).resolve().parents[1]
package=json.loads((root/'package.json').read_text())
theme_path=(root/package['contributes']['iconThemes'][0]['path']).resolve()
assert theme_path.is_relative_to(root), 'Icon theme must be within the extension'
src=theme_path.parent;theme=json.loads(theme_path.read_text())
data={'version':package['version'],'upstream':'https://github.com/miguelsolorio/vscode-symbols','colors':{},'extension':theme['fileExtensions'],'file':theme['fileNames'],'directory':theme['folderNames'],'filetype':{},'default':{'file':theme['file'],'directory':theme['folder']}}
for name,definition in theme['iconDefinitions'].items():
 path=(src/definition['iconPath']).resolve();assert path.is_relative_to(src.resolve())
 colors=collections.Counter(x.upper() for x in re.findall(r'#[0-9a-fA-F]{6}',path.read_text()))
 data['colors'][name]=colors.most_common(1)[0][0] if colors else '#64748B'
translation={'csharp':'cs','fsharp':'fsharp','shellscript':'sh','powershell':'ps1','bat':'dosbatch','plaintext':'text','aspnetcorerazor':'razor','git-commit':'gitcommit','git-rebase':'gitrebase','dockerfile':'dockerfile','ignore':'gitignore'}
for ft,icon in theme['languageIds'].items():data['filetype'][translation.get(ft,ft)]=icon
for ext,ft in {'razor':'razor','cshtml':'razor','vue':'vue','jsx':'javascriptreact','tsx':'typescriptreact','jsonc':'json','json5':'json','sln':'csharp','slnx':'csharp'}.items():
 if ext not in data['extension'] and ft in data['filetype']:data['extension'][ext]=data['filetype'][ft]
data['filetype']['jsonc']=data['filetype'].get('json','brackets-yellow')
for alias,name in {'Components':'components','Pages':'pages','Services':'services','Controllers':'controllers','Models':'models','Properties':'config','wwwroot':'public','Resources':'resources','Assets':'assets','Layouts':'layouts','Layout':'layout','Tests':'tests','Views':'views','Data':'database'}.items():
 if name in data['directory']:data['directory'][alias]=data['directory'][name]
out=config/'data';out.mkdir(exist_ok=True)
(out/'symbols-icons.json').write_text(json.dumps(data,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
license=config/'licenses';license.mkdir(exist_ok=True)
(license/'symbols-MIT.txt').write_text((root/'LICENSE.txt').read_text())
print({k:len(data[k]) for k in ['extension','file','filetype','directory']})
