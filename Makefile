IMPORT_STYLE=/usr/share/xml/gnome/xslt/docbook/html/db2html.xsl

html: gnomeja-guide.xml
	gnome-doc-tool html $<

draft: draft.xsl gnomeja-guide.xml
	xsltproc draft.xsl gnomeja-guide.xml

draft.xsl: draft.xsl.in
	sed -e "s|@IMPORT_STYLE@|${IMPORT_STYLE}|" $< > $@

clean:
	rm -f *.html draft.xsl
