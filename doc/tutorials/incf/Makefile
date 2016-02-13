FILES=finding-spikes-incf.markdown extracting-spike-info.markdown load-trace.markdown
HTMLS=$(FILES:%.markdown=$(TARGET)%.html)
DEPS=
TARGET=./
MDCOV=markdown_py

all: $(HTMLS)

.SUFFIXES: .markdown .html

clean:
	/bin/rm -f $(OBJS)

$(TARGET)%.html: %.markdown $(DEPS)
	$(MDCOV) $< -o html4 -f $@
