if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent
setlocal nolisp
setlocal autoindent

setlocal indentexpr=GetJaiIndent(v:lnum)
setlocal indentkeys+=;

if exists("*GetJaiIndent")
  finish
endif

let s:jai_indent_defaults = {
      \ 'default': function('shiftwidth'),
      \ 'case_labels': function('shiftwidth') }

function! s:indent_value(option)
    let Value = exists('b:jai_indent_options')
                \ && has_key(b:jai_indent_options, a:option) ?
                \ b:jai_indent_options[a:option] :
                \ s:jai_indent_defaults[a:option]

    if type(Value) == type(function('type'))
        return Value()
    endif
    return Value
endfunction

function! s:strip_comment(line)
    let comment_start = stridx(a:line, '//')
    if comment_start == -1
        return a:line
    endif 
    if comment_start == 0
        return ''
    endif 

    return a:line[0:comment_start-1]
endfunction

function! GetJaiIndent(lnum)
    let prev = prevnonblank(a:lnum-1)

    if prev == 0
        return 0
    endif

    let prevline = s:strip_comment(getline(prev))
    " echom "Prevline at" prev "was#" getline(prev) "#and is#" prevline "#"
    let line = s:strip_comment(getline(a:lnum))

    let ind = indent(prev)

    if prevline =~ '\v[\(\{\[]\s*$'
        let ind += s:indent_value('default')
        if line =~ 'case\s*\S*;'
            let ind += s:indent_value('case_labels')
        endif
    elseif prevline =~ 'case\s*\S*;'
        let ind += s:indent_value('default')
    endif

    if line =~ '\v^\s*[\)\}\]]'
        let ind -= s:indent_value('default')

        " Find corresponding opening line and check if it’s an if/case
        call cursor(a:lnum, col('.') - 1)
        let opening_linenum = searchpair('{', '', '}', 'bW', 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string"')
        echom "Opened at" opening_linenum
        if opening_linenum > 0 
            let opening_line = getline(opening_linenum)
            echom opening_line
						"First checks if there is a '{' on a newline
						if opening_line =~ '^\s*{\s*'
								let ind = indent(opening_linenum)
						elseif opening_line =~ '==\s*{\s*'
                echom "Matched!"
                " Seems like this was an if/case, so put indentation back at
                " the same level as before opening, no matter how we indented the case statements.
                let ind = indent(opening_linenum)
                echom "Indenting at" ind
            endif 
        endif
    elseif line =~ 'case\s*\S*;'
        let ind -= s:indent_value('default')
    endif

    return ind
endfunction
