if exists("b:current_syntax")
   finish
endif

function! FindJaiModule(filename)
	if !exists('g:jai_modules')
		return a:filename . '.jai'
	endif
	let jai_module=substitute(a:filename,'^',g:jai_modules,'g')
	if isdirectory(jai_module)
		return jai_module . '/module.jai'
	else
		return jai_module . '.jai'
	endif
endfunction

setlocal suffixesadd+=jai
set includeexpr=FindJaiModule(v:fname)
setlocal commentstring=//\ %s

syntax keyword jaiUsing using
syntax keyword jaiCast cast

syntax keyword jaiStruct struct
syntax keyword jaiUnion union
syntax keyword jaiEnum enum enum_flags

syntax keyword jaiIf if
syntax keyword jaiIfx ifx
syntax keyword jaiThen then
syntax keyword jaiElse else
syntax keyword jaiCase case
syntax keyword jaiFor for
syntax keyword jaiContinue continue
syntax keyword jaiBreak break
syntax keyword jaiRemove remove
syntax keyword jaiWhile while

syntax keyword jaiDataType void string int float float32 float64 u8 u16 u32 u64 s8 s16 s32 s64 bool
syntax keyword jaiBool true false
syntax keyword jaiNull null

syntax keyword jaiReturn return
syntax keyword jaiDefer defer

syntax keyword jaiInline inline
syntax keyword jaiNoInline no_inline

syntax keyword jaiSOA SOA
syntax keyword jaiAOS AOS

syntax keyword jaiIt it it_index

syntax keyword jaiTypeInfo size_of type_of type_info
syntax keyword jaiInterface interface
syntax keyword jaiIsConstant is_constant

syntax keyword jaiContext context push_context

syntax keyword jaiOperator operator

syntax keyword jaiInitializerOf initializer_of

syntax keyword jaiAutoCast xx

syntax match jaiFunction "\v<\h\w*>\ze\_s*:[:=]%(\_s*inline)?\_s*\(%(\.\{|\_[^\{;]){-}\)%(\.\{|\_[^{;])*\{"
"The lookahead prevents accidental matches with a function
syntax match jaiConstantDeclaration "\v<\h\w*%(\\\s*\w+)*>\ze%(,\_s*<\h\w*%(\\\s*\w+)*>)*\_s*:\_[^{;:="]{-}:%(\.\{|\_[^{;:])*;" display
"The lookahead prevents accidental matches with a constant declaration or a function
syntax match jaiVariableDeclaration "\v%(%([:\]$]|for%(\_s*\<)?)\_s*)@<!<\h\w*%(\\\s*\w+)*>\ze%(,\_s*<\h\w*%(\\\s*\w+)*>)*\_s*:\_[^:=,"]{-}[=,);]" display
syntax match jaiForVariableDeclaration "\v%(for%(\_s*\<)?%(\_s*<\h\w*%(\\\s*\w+)*>,)*\_s*)@<=<\h\w*%(\\\s*\w+)*>\ze%(,\_s*<\h\w*%(\\\s*\w+)*>)*\_s*:" display
syntax match jaiTagNote "@\<\w\+\>" display

syntax match jaiClass "\v<[A-Z]\w+>" display
syntax match jaiConstant "\v<[A-Z0-9,_]+>" display

syntax match jaiInteger "\<\d\+\>" display
syntax match jaiFloat "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=" display
syntax match jaiHex "\<0[x\|X][0-9A-Fa-f_]\+\>" display
syntax match jaiHexFloat "\<0[h\|H][0-9A-Fa-f_]\+\>" display
syntax match jaiBinary "\<0[b\|B][0-1_]\+\>" display

syntax match jaiDirective "#\<\w\+\>" display

syntax region jaiString start=/\v"/ skip=/\v\\./ end=/\v"/
syntax region jaiHereString matchgroup=jaiDirective start=/\v#string\s*(,\s*cr\s*)?\z(<\w+>)/ end=/\v^\s*\z1/

syntax match jaiTemplate "$\<\w\+\>" display
syntax match jaiAutobake "$$\<\w\+\>" display

syntax match jaiCommentNote "@\<\w\+\>" contained display
syntax match jaiLineComment "//.*" contains=jaiCommentNote
syntax region jaiBlockComment start=/\v\/\*/ end=/\v\*\// contains=jaiBlockComment, jaiCommentNote
" Maybe scan back to find the beginning of block comments?
syntax sync minlines=200


highlight def link jaiIt Identifier
highlight def link jaiUsing Keyword
highlight def link jaiNew Keyword
highlight def link jaiCast Keyword
highlight def link jaiAutoCast Keyword
highlight def link jaiDelete Keyword
highlight def link jaiReturn Keyword
highlight def link jaiDefer Keyword
highlight def link jaiTypeInfo Keyword
highlight def link jaiInterface Keyword
highlight def link jaiIsConstant Keyword
highlight def link jaiContext Keyword
highlight def link jaiOperator Keyword
highlight def link jaiInitializerOf Keyword

highlight def link jaiInline Keyword
highlight def link jaiNoInline Keyword

highlight def link jaiString String
highlight def link jaiHereString String

highlight def link jaiStruct Structure
highlight def link jaiUnion Structure
highlight def link jaiEnum Structure

highlight def link jaiFunction Function
highlight def link jaiVariableDeclaration Identifier
highlight def link jaiForVariableDeclaration Identifier
highlight def link jaiConstantDeclaration Constant

highlight def link jaiDirective PreProc
highlight def link jaiIf Conditional
highlight def link jaiIfx Conditional
highlight def link jaiThen Conditional
highlight def link jaiElse Conditional
highlight def link jaiCase Conditional
highlight def link jaiContinue Keyword
highlight def link jaiBreak Keyword
highlight def link jaiRemove Keyword
highlight def link jaiFor Repeat
highlight def link jaiWhile Repeat

highlight def link jaiLineComment Comment
highlight def link jaiBlockComment Comment
highlight def link jaiCommentNote Todo

highlight def link jaiClass Type

highlight def link jaiTemplate Constant
highlight def link jaiAutobake Constant

highlight def link jaiTagNote Identifier
highlight def link jaiDataType Type
highlight def link jaiBool Boolean
highlight def link jaiConstant Constant
highlight def link jaiNull Type
highlight def link jaiInteger Number
highlight def link jaiFloat Float
highlight def link jaiHex Number
highlight def link jaiHexFloat Number
highlight def link jaiBinary Number

highlight def link jaiSOA Keyword
highlight def link jaiAOS Keyword


let b:current_syntax = "jai"
