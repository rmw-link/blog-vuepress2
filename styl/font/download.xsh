#!/usr/bin/env xonsh
from fire import Fire
from os.path import dirname,abspath,join,splitext
import os
import traceback
import urllib.request
import string

# https://fonts.geekzu.org/earlyaccess/notosanstc.css

ALPHABET = string.ascii_uppercase + string.ascii_lowercase + string.digits
BASE = len(ALPHABET)

def num_encode(n):
  assert( n >= 0)
  s = []
  while True:
    n, r = divmod(n, BASE)
    s.append(ALPHABET[r])
    if n == 0: break
  return ''.join(reversed(s))


opener = urllib.request.build_opener()
opener.addheaders = [('User-agent', 'Mozilla/5.0')]
urllib.request.install_opener(opener)

ROOT = dirname(abspath(__file__))

# css from https://fonts.google.com/


@Fire
def main(cssFile):
  name,_ = splitext(cssFile)
  cd @(ROOT)
  li = []
  def line_url(i):
    return i.split("(")[1].split(")")[0]

  fontFamily = None
  with open(cssFile) as f:
    for i in f:
      i = i.strip()
      if fontFamily is None:
        if i.startswith('font-family'):
          fontFamily = i.split(":").pop().strip(';')
      if "url(" in i:
        url = line_url(i)
        if url:
          li.append(url)

  assert(fontFamily is not None)
  outdir = abspath(join(ROOT,"../../public/f", name))
  os.makedirs(outdir, exist_ok=True)

  filemap = {}
  n = 0
  for url in li:
    downurl = url.replace("'",'').replace("fonts.gstatic.com","cn-gapis.0cdn.cn/g-fonts")
    _,suffix = splitext(url)
    suffix = suffix.strip('"\'')
    outfile = join(f"{num_encode(n)}{suffix}")
    n += 1
    print(downurl,outfile)
    urllib.request.urlretrieve(downurl,join(outdir,outfile))

    filemap[url]=outfile

  outLi = []
  with open(join(ROOT,cssFile)) as f:
    for i in f:
      i=i.strip()
      if "url(" in i:
        url = line_url(i)
        i = i.replace(
            url,
            "/f/"+name+"/"+filemap[url])
      outLi.append(i.replace(fontFamily, name))

  with open(join(ROOT,name+'.styl'),"w") as f:
    f.write("\n".join(outLi))
