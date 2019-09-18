FROM centos:7

MAINTAINER Evgeny Tevelevich "eyt5297@gmail.com"


ADD buildit.sh /tmp/buildit.sh

WORKDIR /tmp

RUN sh ./buildit.sh

ENTRYPOINT ["/usr/sbin/asterisk"]
CMD ["-c", "-vvvv", "-g"]
