emacs ?= emacs
wget ?= wget

el = w32-registry-mode.el
elc = $(el:.el=.elc)

auto=../loaddefs.el
auto_flags= \
	--eval "(let ((generated-autoload-file \
	(expand-file-name (unmsys--file-name \"$@\"))) \
	(backup-inhibited t)) \
	(update-directory-autoloads \".\"))"

.PHONY: $(auto) clean
all: compile $(auto) README.md

compile : $(elc)
%.elc : %.el
	$(emacs) -batch -f byte-compile-file $<

$(auto):
	$(emacs) -batch $(auto_flags)

README.md: el2markdown.el $(el)
	$(emacs) -batch -l $< $(el) -f el2markdown-write-readme

.INTERMEDIATE: el2markdown.el
el2markdown.el:
	$(wget) -q -O $@ "https://github.com/Lindydancer/el2markdown/raw/master/el2markdown.el"

clean:
	$(RM) *.elc *~ *autoloads.el
