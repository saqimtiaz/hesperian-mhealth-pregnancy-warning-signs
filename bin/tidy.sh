#!/bin/sh
#
# Apply html tidy with HM options.
# 
# tidy strips out empty tags - which we use for a
# <span class="clear"></span> construct on which to hook css.
# so, we put a html comment in the span before passing to tidy, which is
# enough to let it survive. Then, we post-remove the html comment.
#

TIDY_OPTS="-utf8 -i --indent-spaces 4 --hide-comments 1 --drop-proprietary-attributes 0 -q -f tidy.log"

cat | sed "s:<span class=\"clear\"></span>:<span class=\"clear\"><!--tidy--></span>:g" \
| tidy ${TIDY_OPTS} \
| sed "s:<span class=\"clear\"><!--tidy--></span>:<span class=\"clear\"></span>:g"
