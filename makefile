.PHONY: all install uninstall

all:
	ocamlbuild -use-ocamlfind iocamllib.cma

clean:
	ocamlbuild -clean
	- rm -fr *~

install:
	ocamlfind install iocamllib META _build/iocamllib.cma \
		_build/*.cmi _build/*.cmti _build/*.cmt

uninstall:
	ocamlfind remove iocamllib

