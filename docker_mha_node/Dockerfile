FROM mysql:5.6

COPY ./preparation /preparation
RUN build_deps='ssh sshpass perl libdbi-perl libmodule-install-perl libdbd-mysql-perl make' \
    && pack='/preparation' \
    && apt-get clean \
    && apt-get update \
    && apt-get -y --force-yes install $build_deps \
    && sed -n -i 's/UsePAM yes/UsePAM no/gp' /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && tar -zxf $pack/mha4mysql-node-0.54.tar.gz -C /opt \
    && cd /opt/mha4mysql-node-0.54 \
    && perl Makefile.PL \
    && make \
    && make install \
    && rm -rf /opt/mha4mysql-node-0.54