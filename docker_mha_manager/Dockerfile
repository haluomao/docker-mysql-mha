FROM debian:jessie

COPY ./preparation /preparation
RUN build_deps='ssh sshpass supervisor perl libdbi-perl libmodule-install-perl libdbd-mysql-perl \
    libconfig-tiny-perl liblog-dispatch-perl libparallel-forkmanager-perl make haproxy' \
    && pack='/preparation' \
    && mkdir -p /var/cache/apt/archives \
    && apt-get clean \
    && apt-get update \
    && apt-get -y --force-yes install $build_deps \
    && sed -n -i 's/UsePAM yes/UsePAM no/gp' /etc/ssh/sshd_config \
    && tar -zxf $pack/mha4mysql-node-0.54.tar.gz -C /opt \
    && cd /opt/mha4mysql-node-0.54 \
    && perl Makefile.PL \
    && make \
    && make install \
    && tar -zxf $pack/mha4mysql-manager-0.55.tar.gz -C /opt \
    && cd /opt/mha4mysql-manager-0.55 \
    && perl Makefile.PL \
    && make \
    && make install \
    && rm -rf /opt/mha4mysql-*
