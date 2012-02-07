# -*- coding: utf-8-unix -*-
IMPORT_STYLE=/usr/share/xml/gnome/xslt/docbook/html/db2html.xsl

JAMAINFONT=IPA明朝
JASANSFONT=IPAゴシック
JAMONOFONT=IPAゴシック
# JAMAINFONT=IPA明朝
# JASANSFONT=VL ゴシック
# JAMONOFONT=VL ゴシック
# JAMAINFONT=IPA明朝
# JASANSFONT=IPAゴシック
# JAMONOFONT=VL ゴシック
# JAMAINFONT=ヒラギノ明朝 ProN W3
# JASANSFONT=ヒラギノ角ゴ ProN W3
# JAMONOFONT=ヒラギノ丸ゴ ProN W4
PAPERSIZE=b5paper
# PAPERSIZE=a4paper

html: gnomeja-guide.xml
	gnome-doc-tool html $<

draft: draft.xsl gnomeja-guide.xml
	xsltproc draft.xsl gnomeja-guide.xml

draft.xsl: draft.xsl.in
	sed -e "s|@IMPORT_STYLE@|${IMPORT_STYLE}|" $< > $@

pdf: gnomeja-guide.tex
	for x in 1 2 3; do \
	  xelatex -file-line-error -interaction=nonstopmode $< < /dev/null || exit 1; \
	  grep 'Rerun to get cross-references right.' $(<:.tex=.log) || \
	  grep 'Package hyperref Warning: Rerun to get /PageLabels entry.' $(<:.tex=.log) || \
	  exit 0; \
	done

gnomeja-guide.tex: gnomeja-guide.xml gnomeja-guide-param.xsl 88x31.png
	dblatex -t tex -p gnomeja-guide-param.xsl gnomeja-guide.xml
	sed -i -e "s,http://i.creativecommons.org/l/by-sa/2.1/jp/,,g" $@ || exit 1

	for png in `find figures -name "*.png"`; do \
	    pdf=figures/`basename $${png} .png`.pdf; \
	    convert $${png} $${pdf}; \
	    sed -i -e "s|$${png}|$${pdf}|g" gnomeja-guide.tex; \
	done

gnomeja-guide-param.xsl: gnomeja-guide-param.xsl.in
	sed -e "s|@@JAMAINFONT@@|${JAMAINFONT}|" \
	    -e "s|@@JASANSFONT@@|${JASANSFONT}|" \
	    -e "s|@@JAMONOFONT@@|${JAMONOFONT}|" \
	    -e "s|@@PAPERSIZE@@|${PAPERSIZE}|" $< > $@

88x31.png:
	wget http://i.creativecommons.org/l/by-sa/2.1/jp/88x31.png

clean:
	rm -f *.html draft.xsl
	rm -f 88x31.png
	rm -f figures/*.pdf *~ gnomeja-guide-param.xsl
	rm -f *.aux *.cb *.dvi *.glo *.idx *.lof *.log *.out *.toc
	rm -f *.tex *.pdf

