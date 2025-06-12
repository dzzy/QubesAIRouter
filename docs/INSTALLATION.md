Create a Temporary Git Clone VM

qvm-create sys-git --template fedora-37 --label green --netvm sys-net

Start it and clone the repo inside:

qvm-run -p sys-git 'git clone https://github.com/dzzy/QubesAIRouter ~/QubesAIRouter'

Copy Salt Files from sys-git to dom0

Salt states are in ~/QubesAIRouter/salt and ~/QubesAIRouter/pillar in sys-git.

Use qvm-run or qvm-copy to move files:

qvm-run -p sys-git 'tar -czf /home/user/salt_bundle.tar.gz -C ~/QubesAIRouter salt pillar'

Then in dom0:

sudo mkdir -p /srv/salt /srv/pillar
sudo tar -xzf /tmp/salt_bundle.tar.gz -C /srv

Apply Salt States in dom0

Now run:

sudo qubesctl state.apply

Or apply individual modules:

sudo qubesctl state.apply vm.sys-router

Optional Cleanup

After applying, you can delete the Git VM and bundle:

qvm-remove -f sys-git
rm /tmp/salt_bundle.tar.gz