" Vim compiler file
" Compiler:         Jai
" Maintainer:       Raphael Luba <raphael@leanbyte.com>
" Latest Revision:  2020-10-05

if exists("current_compiler")
  finish
endif
let current_compiler="jai"

function! FindJaiEntrypoint(filename)
	let buildfile = 'first.jai'
	let buildfile2 = 'build.jai'
	if exists("g:jai_entrypoint")
		return g:jai_entrypoint
	else 
		if filereadable(buildfile)
			return buildfile
		else
            if filereadable(buildfile2)
                return buildfile2
            else 
                return a:filename
            endif
		endif
	endif
endfunction

function! FindJaiCompiler()
	if exists("g:jai_compiler")
		return g:jai_compiler
	else
		if has("win64") || has("win32") || has("win16")
			return "jai.exe"
		else
			return "jai-linux"
		endif
	endif
endfunction

let s:backend_flag = "-x64"
if !has("win64")
    let arch = system('uname -m')
    if arch =~ 'x86_64'
        " x64 is fine
    else
        let s:backend_flag = "-llvm"
    endif
endif 

function! GetJaiMakeprg()
    return FindJaiCompiler() . " -no_color -quiet " . s:backend_flag . " " . FindJaiEntrypoint(expand('%'))
endfunction

function! UpdateJaiMakeprg()
    let &l:makeprg=GetJaiMakeprg()
endfunction

call UpdateJaiMakeprg()

let s:cpo_save = &cpo
set cpo-=C

CompilerSet errorformat=
	\%f:%l\\,%c:\ Error:\ %m,
	\%f:%l\\,%c:\ %m,
	\%m\ (%f:%l),
execute "CompilerSet makeprg=" . escape(GetJaiMakeprg(), ' ')

let &cpo = s:cpo_save
unlet s:cpo_save
