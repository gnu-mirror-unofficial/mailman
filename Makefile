HT2HTML = $(HOME)/projects/ht2html/ht2html.py

HTSTYLE = MMGenerator
HTALLFLAGS = -f -s $(HTSTYLE)
HTROOT = .
HTFLAGS = $(HTALLFLAGS) -r $(HTROOT)
HTRELDIR = .
# Use args for rsync like -a without the permission setting flag.  I want to
# keep the permissions set the way they are on the destination files, not on
# my source files.  Also add verbosity, compression, and ignoring CVS.
RSYNC_ARGS = -rltgoDCvz

SOURCES =	$(shell echo *.ht)
TARGETS =	$(filter-out *.html,$(SOURCES:%.ht=%.html)) $(EXTRA_TARGETS)
GENERATED_HTML= $(SOURCES:.ht=.html)

.SUFFIXES:	.ht .html
.ht.html:
	$(HT2HTML) $(HTFLAGS) $(HTRELDIR)/$<

all: $(TARGETS) mailman.html

mailman.html: index.html
	cp index.html mailman.html

docs:
	cp ../doc/.-admin/*.html ../doc/.-admin/*.png ../doc/.-admin/*.css mailman-admin/
	cp ../doc/.-install/*.html ../doc/.-install/*.png ../doc/.-install/*.css mailman-install/
	cp ../doc/.-member/*.html ../doc/.-member/*.png ../doc/.-member/*.css mailman-member/
	cp ../doc/.-member-es/*.html ../doc/.-member-es/*.png ../doc/.-member-es/*.css mailman-member-es/
	cp ../doc/*.dvi ../doc/*.pdf ../doc/mailman*.ps ../doc/*.txt .

install:
	-rsync $(RSYNC_ARGS) . www.list.org:mailman.list.org
	-rsync $(RSYNC_ARGS) . $(USER),mailman@web.sourceforge.net:htdocs/
	-rsync $(RSYNC_ARGS) . $(HOME)/projects/mailman-gnu

clean:
	-rm $(GENERATED_HTML)
