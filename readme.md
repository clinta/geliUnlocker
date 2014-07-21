# GeliUnlocker

### A rc.d script to automatically unlock geli encrypted disks using key and passphrase files stored on a remote system accessed via SSH.

## Use Cases


1. Encrypt your disks on your VPS, store the keys and passphrases on a server on premise. Your remote VPS can reboot with no user interaction as long as your on premise server hosting the keys is up.
2. Store the key file and passphrase file on two different remote systems if you like. Both systems must be up for your disks to be successfully decrypted.
3. Coming Soon: Encrypt the keys on the remote system so they can be stored on untrusted systems.

## How to Install:

1. Copy the geliunlock script to /usr/local/etc/rc.d/
`fetch https://raw.githubusercontent.com/clinta/geliUnlocker/master/unlockgeli /usr/local/etc/rc.d/
`chmod +x /usr/local/etc/rc.d

## How to Use:

You need an account on a remote system with scp access via public key authentication using a key with no passphrase. If doing this on a vps, you might want to consider creating a user just for this purpose and restricting their login schell to scp only.

The private key for ssh authentication to the remove server must be stored somehwere that is not on one of your encrypted disks.

Copy your geli key file to your remote host. Create a passphrase file (a text file containing your passphrase to your geli disk) and put it on the same, or a different remote host.

Configure your automatic decryption in rc.conf:
```
netwait_enable="YES"			# If netwait is enabled, geliunlock will wait to run until the default gateway responds to ping to run.

unlockgeli_enable="YES"			# Enable teh unlockgeli script
unlockgeli_pools="tank docs"		# A list of groups of disks. These do not necessarily have to correspond to zfs pools, but they often will.
					# They are disks that all share the same geli key and passphrase.

					# All further options will be specific to a pool. You can also create options for pools that are not listed in 
					# unlockgeli_pools for quick unlocking of pools of disks manually.

unlockgeli_tank_devs="/dev/da1 /dev/da2 /dev/gptid/96235f62-1074-11e4-a04d-50e549c81799"	# Devices belonging to the pool listed above are defined here.
unlockgeli_tank_key="bob@192.168.1.24:/home/bob/geli.key"					# scp syntax path to the geli key file
unlockgeli_tank_key_identityfile="/root/bob.id-rsa"						# The ssh key file for this server

unlockgeli_tank_passphrase="tom@192.168.1.53:/home/tom/geli.pw"					# scp syntax path to the geli passphrase file
unlockgeli_tank_passphrase_identityfile="/root/tom.id-rsa"					# the ssh key file for this server

```

At the end of the script `zfs mount -a` is called, so any zfs datasets on the newly decrypted disks should be mounted. Also this script will attempt to run before jail, so any jails stored on these encrypted volumes can run on boot.
