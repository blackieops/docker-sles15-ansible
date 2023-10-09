# SLES 15 Ansible Test Image

A container to test Ansible playbooks against SLES 15 using the official SLES
15 BCI upstream images.

## Usage

The intended use case for this image is with [molecule] for Ansible testing.

An example `molecule/default/molecule.yml`:

```yaml
---
role_name_check: 1
driver:
  name: docker
platforms:
  - name: instance
    image: "ghcr.io/blackieops/docker-${MOLECULE_DISTRO:-sles15}-ansible:latest"
    command: ${MOLECULE_DOCKER_COMMAND:-""}
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroupns_mode: host
    privileged: true
    pre_build_image: true
provisioner:
  name: ansible
  playbooks:
    converge: ${MOLECULE_PLAYBOOK:-converge.yml}
```

[molecule]: https://github.com/ansible/molecule
