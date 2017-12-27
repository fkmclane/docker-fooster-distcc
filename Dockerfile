FROM samuelololol/docker-gentoo-crossdev-distccd

MAINTAINER Foster McLane <fkmclane@gmail.com>

RUN echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf && \
    emerge -uDN @world
RUN rm -r /usr/portage

CMD ["/usr/local/sbin/distccd-launcher", "--allow", "0.0.0.0/0", "--user", "distcc", "--log-level", "notice", "--log-stderr", "--no-detach"]

EXPOSE 3632
