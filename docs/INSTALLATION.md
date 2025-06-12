# Installation Guide

## 1. Create a Temporary Git Clone VM

```bash
qvm-create sys-git --template fedora-37 --label green --netvm sys-net
```

Start it and clone the repo inside:

```bash
qvm-run -p sys-git 'git clone https://github.com/dzzy/QubesAIRouter ~/QubesAIRouter'
```

## 2. Copy Salt Files from sys-git to dom0

Salt states are in `~/QubesAIRouter/salt` and `~/QubesAIRouter/pillar` in `sys-git`.

Use `qvm-run` or `qvm-copy` to move files:

```bash
qvm-run -p sys-git 'tar -czf /home/user/salt_bundle.tar.gz -C ~/QubesAIRouter salt pillar'
qvm-run --pass-io sys-git 'cat /home/user/salt_bundle.tar.gz' > /tmp/salt_bundle.tar.gz
```

Then in `dom0`:

```bash
sudo mkdir -p /srv/salt /srv/pillar
sudo tar -xzf /tmp/salt_bundle.tar.gz -C /srv
```

## 3. Apply Salt States in dom0

Apply all states:

```bash
sudo qubesctl state.apply
```

Or apply individual modules:

```bash
sudo qubesctl state.apply vm.sys-router
```

## 4. Unpack the Repository Automatically with Salt

You can define a Salt state at `/srv/salt/vm/unpack_repo.sls` like this:

```yaml
/srv/salt:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/srv/pillar:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/tmp/salt_bundle.tar.gz:
  file.exists

unpack-salt-bundle:
  cmd.run:
    - name: tar -xzf /tmp/salt_bundle.tar.gz -C /srv
    - unless: test -d /srv/salt/vm
```

Then apply it:

```bash
sudo qubesctl state.apply vm.unpack_repo
```

## 5. Optional Cleanup

After applying, you can delete the Git VM and bundle:

```bash
qvm-remove -f sys-git
rm /tmp/salt_bundle.tar.gz
```