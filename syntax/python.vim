
if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "python"

" Commands
command! -buffer Python2Syntax let b:python_version_2 = 1 | let &syntax=&syntax
command! -buffer Python3Syntax let b:python_version_2 = 0 | let &syntax=&syntax

" Enable option if it's not defined
function! s:EnableByDefault(name)
  if !exists(a:name)
    let {a:name} = 1
  endif
endfunction

" Check if option is enabled
function! s:Enabled(name)
  return exists(a:name) && {a:name}
endfunction

" Is it Python 2 syntax?
function! s:Python2Syntax()
  if exists("b:python_version_2")
      return b:python_version_2
  endif
  return s:Enabled("g:python_version_2")
endfunction

" Keywords
syn keyword Statement	    break continue del
syn keyword Statement	    exec return yield
syn keyword Statement	    pass raise
syn keyword Statement	    global nonlocal assert
syn keyword Statement	    lambda
syn keyword Statement	    with
syn keyword Repeat	    for while
syn keyword Conditional	    if elif else
syn keyword Include	    import from as
syn keyword Exception	    try except finally
syn keyword Boolean	    True False
syn keyword Keyword	    self None and in is not or 
syn keyword Keyword	    def nextgroup=Function skipwhite
syn keyword Keyword	    class nextgroup=Class skipwhite

syn match Class /\C\<[A-Z]\+[a-z0-9]\w*\>/


if s:Python2Syntax()
  if !s:Enabled("g:python_print_as_function")
    syn keyword Statement  print
  endif
  syn match   Function    "[a-zA-Z_][a-zA-Z0-9_]*" display contained
else
  syn match   Function    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
endif

" Decorators (new in Python 2.4)
syn match   pythonDecorator	"@" display nextgroup=pythonDottedName skipwhite
syn match   pythonDottedName "[a-zA-Z_][a-zA-Z0-9_]*\%(\.[a-zA-Z_][a-zA-Z0-9_]*\)*" display contained
syn match   pythonDot        "\." display containedin=pythonDottedName

" Comments
syn match   pythonComment	"#.*$" display contains=pythonTodo,@Spell
syn match   pythonRun		"\%^#!.*$"
syn match   pythonCoding	"\%^.*\%(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
syn keyword pythonTodo		TODO FIXME XXX contained

" Errors
syn match pythonError		"\<\d\+\D\+\>" display
syn match pythonError		"[$?]" display
syn match pythonError		"[&|]\{2,}" display
syn match pythonError		"[=]\{3,}" display

" Mixing spaces and tabs also may be used for pretty formatting multiline
syn match pythonIndentError	"^\s*\%( \t\|\t \)\s*\S"me=e-1 display
" Trailing space errors
syn match pythonSpaceError	"\s\+$" display

" Strings
if s:Python2Syntax()
  " Python 2 strings
  syn region pythonString   start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+[bB]\="""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonString   start=+[bB]\='''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
else
  " Python 3 byte strings
  syn region pythonBytes		start=+[bB]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
  syn region pythonBytes		start=+[bB]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
  syn region pythonBytes		start=+[bB]"""+ end=+"""+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonBytes		start=+[bB]'''+ end=+'''+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest,pythonSpaceError,@Spell

  syn match pythonBytesError    ".\+" display contained
  syn match pythonBytesContent  "[\u0000-\u00ff]\+" display contained contains=pythonBytesEscape,pythonBytesEscapeError
endif

syn match pythonBytesEscape       +\\[abfnrtv'"\\]+ display contained
syn match pythonBytesEscape       "\\\o\o\=\o\=" display contained
syn match pythonBytesEscapeError  "\\\o\{,2}[89]" display contained
syn match pythonBytesEscape       "\\x\x\{2}" display contained
syn match pythonBytesEscapeError  "\\x\x\=\X" display contained
syn match pythonBytesEscape       "\\$"

syn match pythonUniEscape         "\\u\x\{4}" display contained
syn match pythonUniEscapeError    "\\u\x\{,3}\X" display contained
syn match pythonUniEscape         "\\U\x\{8}" display contained
syn match pythonUniEscapeError    "\\U\x\{,7}\X" display contained
syn match pythonUniEscape         "\\N{[A-Z ]\+}" display contained
syn match pythonUniEscapeError    "\\N{[^A-Z ]\+}" display contained

if s:Python2Syntax()
  " Python 2 Unicode strings
  syn region pythonUniString  start=+[uU]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonUniString  start=+[uU]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonUniString  start=+[uU]"""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonUniString  start=+[uU]'''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
else
  " Python 3 strings
  syn region pythonString   start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+"""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonString   start=+'''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
endif

if s:Python2Syntax()
  " Python 2 Unicode raw strings
  syn region pythonUniRawString start=+[uU][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
  syn region pythonUniRawString start=+[uU][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
  syn region pythonUniRawString start=+[uU][rR]"""+ end=+"""+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonUniRawString start=+[uU][rR]'''+ end=+'''+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest,pythonSpaceError,@Spell

  syn match  pythonUniRawEscape       "\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
  syn match  pythonUniRawEscapeError  "\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained
endif

" Python 2/3 raw strings
if s:Python2Syntax()
  syn region pythonRawString  start=+[bB]\=[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell
else
  syn region pythonRawString  start=+[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawString  start=+[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell

  syn region pythonRawBytes  start=+[bB][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawBytes  start=+[bB][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawBytes  start=+[bB][rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawBytes  start=+[bB][rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell
endif

syn match pythonRawEscape +\\['"]+ display transparent contained

" % operator string formatting
if s:Python2Syntax()
    syn match pythonStrFormatting	"%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrFormatting	"%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
else
    syn match pythonStrFormatting	"%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
    syn match pythonStrFormatting	"%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
endif

" str.format syntax
if s:Python2Syntax()
    syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrFormat	"{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
else
    syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonRawString
    syn match pythonStrFormat	"{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonRawString
endif

" string.Template format
if s:Python2Syntax()
    syn match pythonStrTemplate	"\$\$" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrTemplate	"\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrTemplate	"\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
else
    syn match pythonStrTemplate	"\$\$" contained containedin=pythonString,pythonRawString
    syn match pythonStrTemplate	"\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonRawString
    syn match pythonStrTemplate	"\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonRawString
endif

" DocTests
syn region pythonDocTest	start="^\s*>>>" end=+'''+he=s-1 end="^\s*$" contained
syn region pythonDocTest2	start="^\s*>>>" end=+"""+he=s-1 end="^\s*$" contained

" Numbers (ints, longs, floats, complex)
if s:Python2Syntax()
  syn match   pythonHexError	"\<0[xX]\x*[g-zG-Z]\+\x*[lL]\=\>" display
  syn match   pythonOctError	"\<0[oO]\=\o*\D\+\d*[lL]\=\>" display
  syn match   pythonBinError	"\<0[bB][01]*\D\+\d*[lL]\=\>" display

  syn match   pythonHexNumber	"\<0[xX]\x\+[lL]\=\>" display
  syn match   pythonOctNumber "\<0[oO]\o\+[lL]\=\>" display
  syn match   pythonBinNumber "\<0[bB][01]\+[lL]\=\>" display

  syn match   pythonNumberError	"\<\d\+\D[lL]\=\>" display
  syn match   pythonNumber	"\<\d[lL]\=\>" display
  syn match   pythonNumber	"\<[0-9]\d\+[lL]\=\>" display
  syn match   pythonNumber	"\<\d\+[lLjJ]\>" display

  syn match   pythonOctError	"\<0[oO]\=\o*[8-9]\d*[lL]\=\>" display
  syn match   pythonBinError	"\<0[bB][01]*[2-9]\d*[lL]\=\>" display
else
  syn match   pythonHexError	"\<0[xX]\x*[g-zG-Z]\x*\>" display
  syn match   pythonOctError	"\<0[oO]\=\o*\D\+\d*\>" display
  syn match   pythonBinError	"\<0[bB][01]*\D\+\d*\>" display

  syn match   pythonHexNumber	"\<0[xX]\x\+\>" display
  syn match   pythonOctNumber "\<0[oO]\o\+\>" display
  syn match   pythonBinNumber "\<0[bB][01]\+\>" display

  syn match   pythonNumberError	"\<\d\+\D\>" display
  syn match   pythonNumberError	"\<0\d\+\>" display
  syn match   pythonNumber	"\<\d\>" display
  syn match   pythonNumber	"\<[1-9]\d\+\>" display
  syn match   pythonNumber	"\<\d\+[jJ]\>" display

  syn match   pythonOctError	"\<0[oO]\=\o*[8-9]\d*\>" display
  syn match   pythonBinError	"\<0[bB][01]*[2-9]\d*\>" display
endif

syn match   pythonFloat		"\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+\.\d*\%([eE][+-]\=\d\+\)\=[jJ]\=" display

" Builtin objects and types
syn keyword pythonBuiltinObj	Ellipsis NotImplemented
syn keyword pythonBuiltinObj	__debug__ __doc__ __file__ __name__ __package__

" Builtin functions
if s:Python2Syntax()
    syn keyword pythonBuiltinFunc	apply basestring buffer callable coerce
    syn keyword pythonBuiltinFunc	execfile file help intern long raw_input
    syn keyword pythonBuiltinFunc	reduce reload unichr unicode xrange
    syn keyword pythonBuiltinFunc	ascii exec memoryview
endif

syn keyword pythonBuiltinFunc	__import__ abs all any print
syn keyword pythonBuiltinFunc	bin bool bytearray bytes
syn keyword pythonBuiltinFunc	chr classmethod cmp compile complex
syn keyword pythonBuiltinFunc	delattr dict dir divmod enumerate eval
syn keyword pythonBuiltinFunc	filter float format frozenset getattr
syn keyword pythonBuiltinFunc	globals hasattr hash hex id
syn keyword pythonBuiltinFunc	input int isinstance
syn keyword pythonBuiltinFunc	issubclass iter len list locals map max
syn keyword pythonBuiltinFunc	min next object oct open ord
syn keyword pythonBuiltinFunc	pow property range
syn keyword pythonBuiltinFunc	repr reversed round set setattr
syn keyword pythonBuiltinFunc	slice sorted staticmethod str sum super tuple
syn keyword pythonBuiltinFunc	type vars zip


hi def link pythonDecorator        Function
hi def link pythonDottedName       Function
hi def link pythonDot              Function

hi def link pythonComment          Comment
hi def link pythonCoding           Comment
hi def link pythonRun              Comment
hi def link pythonTodo             Todo

hi def link pythonError            Error
hi def link pythonIndentError      Error
hi def link pythonSpaceError       Error

hi def link pythonString           String
hi def link pythonRawString        String

hi def link pythonUniEscape        Special
hi def link pythonUniEscapeError   Error

if s:Python2Syntax()
    hi def link pythonUniString          String
    hi def link pythonUniRawString       String
    hi def link pythonUniRawEscape       Special
    hi def link pythonUniRawEscapeError  Error
else
    hi def link pythonBytes              String
    hi def link pythonRawBytes           String
    hi def link pythonBytesContent       String
    hi def link pythonBytesError         Error
    hi def link pythonBytesEscape        Special
    hi def link pythonBytesEscapeError   Error
endif

hi def link pythonStrFormatting    Special
hi def link pythonStrFormat        Special
hi def link pythonStrTemplate      Special

hi def link pythonDocTest          Special
hi def link pythonDocTest2         Special

hi def link pythonNumber           Number
hi def link pythonHexNumber        Number
hi def link pythonOctNumber        Number
hi def link pythonBinNumber        Number
hi def link pythonFloat            Float
hi def link pythonNumberError      Error
hi def link pythonOctError         Error
hi def link pythonHexError         Error
hi def link pythonBinError         Error

hi def link pythonBuiltinObj       Structure
hi def link pythonBuiltinFunc      Function

