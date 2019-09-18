FROM centos:7

MAINTAINER Evgeny Tevelevich "eyt5297@gmail.com"


ADD buildit.sh /tmp/buildit.sh

WORKDIR /tmp

RUN sh ./buildit.sh

ENTRYPOINT ["/bin/bash"]
