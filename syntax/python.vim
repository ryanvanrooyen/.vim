" Vim syntax file
" Language:	Python

" For version 5.x: Clear all syntax items.
" For version 6.x: Quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

" Keep Python keywords in alphabetical order inside groups for easy
" comparison with the table in the 'Python Language Reference'
" https://docs.python.org/2/reference/lexical_analysis.html#keywords,
" https://docs.python.org/3/reference/lexical_analysis.html#keywords.
" Groups are in the order presented in NAMING CONVENTIONS in syntax.txt.
" Exceptions come last at the end of each group (class and def below).
"
" Keywords 'with' and 'as' are new in Python 2.6
" (use 'from __future__ import with_statement' in Python 2.5).
"
" Some compromises had to be made to support both Python 3 and 2.
" We include Python 3 features, but when a definition is duplicated,
" the last definition takes precedence.
"
" - 'exec' is a built-in in Python 3 and will be highlighted as
"   built-in below.
" - 'nonlocal' is a keyword in Python 3 and will be highlighted.
" - 'print' is a built-in in Python 3 and will be highlighted as
"   built-in below (use 'from __future__ import print_function' in 2)
" - async and await were added in Python 3.5 and are soft keywords.
"
syn keyword pythonDefinition	class nextgroup=pythonClass skipwhite
syn keyword pythonDefinition	def nextgroup=pythonFunction skipwhite

syn keyword pythonSelf		self 
syn keyword pythonNone		None
syn keyword pythonBoolean	False True
syn keyword pythonStatement	as assert break continue del exec global
syn keyword pythonStatement	lambda nonlocal pass print return with
syn keyword pythonConditional	elif else if
syn keyword pythonRepeat	for while
syn keyword pythonOperator	and in is not or
syn keyword pythonException	except finally raise try
syn keyword pythonInclude	import
syn keyword pythonAsync		async await

" Generators (yield from: Python 3.3)
syn match pythonInclude   "\<from\>" display
syn match pythonStatement "\<yield\>" display
syn match pythonStatement "\<yield\s\+from\>" display

" pythonExtra(*)Operator
syn match pythonExtraOperator       "\%([~!^&|*/%+-]\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|=\@<!>\|\*\*\|\.\.\.\|\.\.\|::\|=\)"
syn match pythonExtraPseudoOperator "\%(-=\|/=\|\*\*=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!\~\|!=\)"

syn region pythonFuncCall	start="\s*\zs\(\<_*[a-z]\+\w*\)\+\ze(" end=")" contains=pythonFunctionCallVars keepend extend

" Decorators (new in Python 2.4)
syn match   pythonDecorator	"@" display nextgroup=pythonFunction skipwhite
" The zero-length non-grouping match before the function name is
" extremely important in pythonFunction.  Without it, everything is
" interpreted as a function inside the contained environment of
" doctests.
" A dot must be allowed because of @MyClass.myfunc decorators.

" Bracket symbols
syn match pythonBrackets "[(|)]" contained skipwhite

" Classes
syn match  pythonClass /\<[A-Z]\+\w*\>/
syn region pythonClassCall	start="\s*\zs\(\<[A-Z]\+\w*\)\+\ze(" end=")" contains=pythonFunctionCallVars keepend extend
syn match  pythonClassDef "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonClassVars
syn region pythonClassVars start="(" end=")" contained contains=pythonClassParameters transparent keepend
syn match  pythonClassParameters "[^,]*" contained contains=pythonExtraOperator,pythonBuiltin,pythonBuiltinClass,pythonConstant,pythonBoolean,pythonStatement,pythonNumber,pythonString,pythonBrackets skipwhite

" Function parameters
syn match  pythonFunction "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonFunctionDefVars
syn region pythonFunctionDefVars start="(" end=")" contained contains=pythonFunctionDefParameters transparent keepend
syn region pythonFunctionCallVars start="(" end=")" contained contains=pythonFunctionCallParameters
syn match  pythonFunctionDefParameters "[^,]*" contained contains=pythonSelf,pythonKeywordArg,pythonExtraOperator,pythonConstant,pythonNone,pythonBoolean,pythonStatement,pythonNumber,pythonString,pythonBrackets skipwhite
syn match  pythonFunctionCallParameters "[^,]*" contained contains=pythonSelf,pythonKeywordArg,pythonOperator,pythonExtraOperator,pythonBuiltin,pythonBuiltinClass,pythonNone,pythonBoolean,pythonConditional,pythonRepeat,pythonBrackets,pythonStatement,pythonNumber,pythonString,pythonFuncCall,pythonClassCall,pythonFunctionCallVars skipwhite

syn match pythonKeywordArg "\s*\zs\w\+\ze\s*=[^=]" contained keepend
syn match test "blah" contained 

syn match   pythonComment	"#.*$" contains=pythonTodo,@Spell
syn keyword pythonTodo		FIXME NOTE NOTES TODO XXX contained

" Triple-quoted strings can contain doctests.
syn region  pythonString matchgroup=pythonQuotes
      \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=pythonEscape,@Spell
syn region  pythonString matchgroup=pythonTripleQuotes
      \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell
syn region  pythonRawString matchgroup=pythonQuotes
      \ start=+[uU]\=[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  pythonRawString matchgroup=pythonTripleQuotes
      \ start=+[uU]\=[rR]\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonSpaceError,pythonDoctest,@Spell

syn match   pythonEscape	+\\[abfnrtv'"\\]+ contained
syn match   pythonEscape	"\\\o\{1,3}" contained
syn match   pythonEscape	"\\x\x\{2}" contained
syn match   pythonEscape	"\%(\\u\x\{4}\|\\U\x\{8}\)" contained
" Python allows case-insensitive Unicode IDs: http://www.unicode.org/charts/
syn match   pythonEscape	"\\N{\a\+\%(\s\a\+\)*}" contained
syn match   pythonEscape	"\\$"

if exists("python_highlight_all")
  if exists("python_no_builtin_highlight")
    unlet python_no_builtin_highlight
  endif
  if exists("python_no_doctest_code_highlight")
    unlet python_no_doctest_code_highlight
  endif
  if exists("python_no_doctest_highlight")
    unlet python_no_doctest_highlight
  endif
  if exists("python_no_exception_highlight")
    unlet python_no_exception_highlight
  endif
  if exists("python_no_number_highlight")
    unlet python_no_number_highlight
  endif
  if exists("python_no_parameter_highlight")
    unlet python_no_parameter_highlight
  endif
  if exists("python_no_operator_highlight")
    unlet python_no_operator_highlight
  endif
  let python_self_cls_highlight = 1
  let python_space_error_highlight = 1
endif


" It is very important to understand all details before changing the
" regular expressions below or their order.
" The word boundaries are *not* the floating-point number boundaries
" because of a possible leading or trailing decimal point.
" The expressions below ensure that all valid number literals are
" highlighted, and invalid number literals are not.  For example,
"
" - a decimal point in '4.' at the end of a line is highlighted,
" - a second dot in 1.0.0 is not highlighted,
" - 08 is not highlighted,
" - 08e0 or 08j are highlighted,
"
" and so on, as specified in the 'Python Language Reference'.
" https://docs.python.org/2/reference/lexical_analysis.html#numeric-literals
" https://docs.python.org/3/reference/lexical_analysis.html#numeric-literals
" numbers (including longs and complex)
syn match   pythonNumber	"\<0[oO]\=\o\+[Ll]\=\>"
syn match   pythonNumber	"\<0[xX]\x\+[Ll]\=\>"
syn match   pythonNumber	"\<0[bB][01]\+[Ll]\=\>"
syn match   pythonNumber	"\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   pythonNumber	"\<\d\+[jJ]\>"
syn match   pythonNumber	"\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   pythonNumber
      \ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
syn match   pythonNumber
      \ "\%(^\|\W\)\zs\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"


" Group the built-ins in the order in the 'Python Library Reference' for
" easier comparison.
" https://docs.python.org/2/library/constants.html
" https://docs.python.org/3/library/constants.html
" http://docs.python.org/2/library/functions.html
" http://docs.python.org/3/library/functions.html
" http://docs.python.org/2/library/functions.html#non-essential-built-in-functions
" http://docs.python.org/3/library/functions.html#non-essential-built-in-functions
" Python built-in functions are in alphabetical order.
" built-in constants
syn keyword pythonBuiltinClass	bool bytearray classmethod complex dict
syn keyword pythonBuiltinClass	float frozenset int list object
syn keyword pythonBuiltinClass	property set slice staticmethod str
syn keyword pythonBuiltinClass	super tuple type 

" built-in functions
" syn keyword pythonBuiltin	NotImplemented Ellipsis __debug__
" syn keyword pythonBuiltin	abs all any bin callable chr
" syn keyword pythonBuiltin	compile delattr dir 
" syn keyword pythonBuiltin	divmod enumerate eval filter format 
" syn keyword pythonBuiltin	getattr globals hasattr hash
" syn keyword pythonBuiltin	help hex id input isinstance
" syn keyword pythonBuiltin	issubclass iter len locals map max
" syn keyword pythonBuiltin	memoryview min next oct open ord pow
" syn keyword pythonBuiltin	print range repr reversed round
" syn keyword pythonBuiltin	setattr sorted sum vars zip __import__

" Python 2 only
" syn keyword pythonBuiltin	basestring cmp execfile file
" syn keyword pythonBuiltin	long raw_input reduce reload unichr
" syn keyword pythonBuiltin	unicode xrange

" Python 3 only
" syn keyword pythonBuiltinClass	bytes
" syn keyword pythonBuiltin	ascii exec

" non-essential built-in functions; Python 2 only
" syn keyword pythonBuiltin	apply buffer coerce intern
" avoid highlighting attributes as builtins
" syn match   pythonAttribute	/\.\h\w*/hs=s+1 contains=ALLBUT,pythonBuiltin transparent


" From the 'Python Library Reference' class hierarchy at the bottom.
" http://docs.python.org/2/library/exceptions.html
" http://docs.python.org/3/library/exceptions.html
" builtin base exceptions (used mostly as base classes for other exceptions)
syn keyword pythonExceptions	BaseException Exception
syn keyword pythonExceptions	ArithmeticError BufferError
syn keyword pythonExceptions	LookupError
" builtin base exceptions removed in Python 3
syn keyword pythonExceptions	EnvironmentError StandardError
" builtin exceptions (actually raised)
syn keyword pythonExceptions	AssertionError AttributeError
syn keyword pythonExceptions	EOFError FloatingPointError GeneratorExit
syn keyword pythonExceptions	ImportError IndentationError
syn keyword pythonExceptions	IndexError KeyError KeyboardInterrupt
syn keyword pythonExceptions	MemoryError NameError NotImplementedError
syn keyword pythonExceptions	OSError OverflowError ReferenceError
syn keyword pythonExceptions	RuntimeError StopIteration SyntaxError
syn keyword pythonExceptions	SystemError SystemExit TabError TypeError
syn keyword pythonExceptions	UnboundLocalError UnicodeError
syn keyword pythonExceptions	UnicodeDecodeError UnicodeEncodeError
syn keyword pythonExceptions	UnicodeTranslateError ValueError
syn keyword pythonExceptions	ZeroDivisionError
" builtin OS exceptions in Python 3
syn keyword pythonExceptions	BlockingIOError BrokenPipeError
syn keyword pythonExceptions	ChildProcessError ConnectionAbortedError
syn keyword pythonExceptions	ConnectionError ConnectionRefusedError
syn keyword pythonExceptions	ConnectionResetError FileExistsError
syn keyword pythonExceptions	FileNotFoundError InterruptedError
syn keyword pythonExceptions	IsADirectoryError NotADirectoryError
syn keyword pythonExceptions	PermissionError ProcessLookupError
syn keyword pythonExceptions	RecursionError StopAsyncIteration
syn keyword pythonExceptions	TimeoutError
" builtin exceptions deprecated/removed in Python 3
syn keyword pythonExceptions	IOError VMSError WindowsError
" builtin warnings
syn keyword pythonExceptions	BytesWarning DeprecationWarning FutureWarning
syn keyword pythonExceptions	ImportWarning PendingDeprecationWarning
syn keyword pythonExceptions	RuntimeWarning SyntaxWarning UnicodeWarning
syn keyword pythonExceptions	UserWarning Warning
" builtin warnings in Python 3
syn keyword pythonExceptions	ResourceWarning


" trailing whitespace
syn match   pythonSpaceError	display excludenl "\s\+$"
" mixed tabs and spaces
syn match   pythonSpaceError	display " \+\t"
syn match   pythonSpaceError	display "\t\+ "


" Do not spell doctests inside strings.
" Notice that the end of a string, either ''', or """, will end the contained
" doctest too.  Thus, we do *not* need to have it as an end pattern.
if !exists("python_no_doctest_code_highlight")
  syn region pythonDoctest
	\ start="^\s*>>>\s" end="^\s*$"
	\ contained contains=ALLBUT,pythonDoctest,@Spell
  syn region pythonDoctestValue
	\ start=+^\s*\%(>>>\s\|\.\.\.\s\|"""\|'''\)\@!\S\++ end="$"
	\ contained
else
  syn region pythonDoctest
	\ start="^\s*>>>" end="^\s*$"
	\ contained contains=@NoSpell
endif


" Sync at the beginning of class, function, or method definition.
" syn sync match pythonSync grouphere NONE "^\s*\%(def\|class\)\s\+\h\w*\s*("

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif


  " The default highlight links.  Can be overridden later.
  HiLink pythonNone		Keyword
  HiLink pythonBoolean		Keyword
  HiLink pythonStatement	Statement
  HiLink pythonDefinition	Keyword
  HiLink pythonConditional	Conditional
  HiLink pythonRepeat		Repeat
  HiLink pythonOperator		Keyword
  HiLink pythonException	Exception
  HiLink pythonInclude		Include
  HiLink pythonAsync		Statement
  HiLink pythonDecorator	Function
  HiLink pythonComment		Comment
  HiLink pythonTodo		Todo
  HiLink pythonString		String
  HiLink pythonRawString	String
  HiLink pythonQuotes		String
  HiLink pythonTripleQuotes	pythonQuotes
  HiLink pythonEscape		Special

  " Classes, Functions
  HiLink pythonClass		Class
  HiLink pythonClassCall	Class
  HiLink pythonClassDef		Class
  HiLink pythonBuiltinClass	Class
  HiLink pythonFunction		Function
  HiLink pythonFuncCall		Function
  HiLink pythonMethodCall	Function
  HiLink pythonKeywordArg	Identifier

  HiLink pythonNumber		Number
  HiLink pythonBuiltin		Function
  HiLink pythonExceptions	Class
  HiLink pythonSpaceError	Error
  HiLink pythonDoctest		Special
  HiLink pythonDoctestValue	Define

  HiLink pythonSelf			Identifier
  HiLink pythonExtraOperator		Operator
  HiLink pythonExtraPseudoOperator	Operator
  HiLink pythonBrackets			Normal
  HiLink pythonClassParameters		Class
  HiLink pythonFunctionDefParameters	Identifier
  " HiLink pythonFunctionCallParameters   Identifier

  delcommand HiLink
endif

let b:current_syntax = "python"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2 ts=8 noet:

