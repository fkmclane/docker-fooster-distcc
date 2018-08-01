FROM samuelololol/docker-gentoo-crossdev-distccd

MAINTAINER Foster McLane <fkmclane@gmail.com>

# configure and upgrade portage
RUN echo 'ACCEPT_KEYWORDS="~amd64"'         >> /etc/portage/make.conf && \
    echo 'FEATURES="-sandbox -usersandbox"' >> /etc/portage/make.conf
RUN emerge -1 portage

# migrate lib
RUN emerge -1 app-portage/unsymlink-lib
RUN unsymlink-lib --analyze
RUN unsymlink-lib --migrate
RUN unsymlink-lib --finish

# update profile
RUN eselect profile set default/linux/amd64/17.1

# remerge gcc and lib32
RUN emerge -1 /usr/lib/gcc /lib32 /usr/lib32

# remove possible remaining symlinks
RUN rm -f /lib32
RUN rm -f /usr/lib32

# remove portage dir
RUN rm -r /usr/portage

# set gcc version
RUN echo 'CHOST="x86_64-pc-linux-gnu"' >> /etc/portage/make.conf
RUN gcc-config `gcc-config -l | tail -n1 | cut -d' ' -f3`

CMD ["/usr/local/sbin/distccd-launcher", "--allow", "0.0.0.0/0", "--user", "distcc", "--log-level", "notice", "--log-stderr", "--no-detach"]

EXPOSE 3632
