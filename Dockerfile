FROM quay.io/app-sre/ubi8-ubi:8.3

LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN yum update -y && yum install -y python3-pip git && pip3 install --no-cache-dir pipenv && yum clean all -y

ADD Pipfile Pipfile.lock /httpbin/
WORKDIR /httpbin
RUN /bin/bash -c "pip3 install --no-cache-dir -r <(pipenv lock -r)"

ADD . /httpbin
RUN pip3 install --no-cache-dir /httpbin

RUN chgrp -R 0 /httpbin && \
    chmod -R g=u /httpbin

EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]
