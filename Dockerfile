# Inspired by Jeff Geerling's work to build an equivalent OpenSUSE image:
#     https://github.com/geerlingguy/docker-opensuseleap15-ansible/blob/bb8c5999e704fe58899c89843d99f054f5c07c73/Dockerfile

FROM registry.suse.com/bci/bci-base:15.5@sha256:c01d001c5e4781dea47b14f0f637321ec607b36043031c557bcfaacf04e52eee

# Install systemd
RUN zypper -n install systemd; zypper clean ; \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*

# Install required packages 
RUN zypper refresh \
 && zypper install -y \
      sudo \
      which \
      hostname \
      python3 \
      python3-pip \
      python3-wheel \
      python3-PyYAML \
 && zypper clean -a

RUN pip3 install ansible

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

# Add Ansible local inventory file
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
