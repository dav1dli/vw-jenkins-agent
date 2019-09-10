FROM registry.redhat.io/openshift4/ose-jenkins-agent-base:latest
LABEL com.redhat.component="jenkins-agent-python-rhel7-container" \
      name="jenkins-agent-python-rhel7" \
      version="4.1" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Python" \
      io.k8s.description="The jenkins build agent Python" \
      io.openshift.tags="openshift,jenkins,agent,python,python3,builder"

ENV PYTHON_VERSION=3.6 \
    PATH=/opt/rh/rh-python36/root/usr/bin:$HOME/.local/bin/:$PATH \
    LD_LIBRARY_PATH=/opt/rh/rh-python36/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

RUN INSTALL_PKGS="rh-python36-python-devel rh-python36-python-pip rh-python36-python-setuptools gcc libcurl-devel httpd httpd-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    rpm -e --nodeps redhat-logos && \
    yum clean all -y && \
    rm -rf /var/cache/yum && \
    pip install --upgrade pip && \
    chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
