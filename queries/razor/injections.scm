; inherits: c_sharp

([
  (html_comment)
  (razor_comment)
] @injection.content
  (#set! injection.language "comment"))

; Keep each element separate. Combining nested elements produces unsorted
; included ranges (parent fragments before child ranges). After incremental
; edits the HTML tree can then retain only the first element's highlights.
; Excluding named children also keeps Razor/C# expressions out of HTML.
((element) @injection.content
  (#set! injection.language "html"))
