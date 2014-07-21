# GeliUnlocker

### A rc.d script to automatically unlock geli encrypted disks using key and passphrase files stored on a remote system accessed via SSH.

## Use Cases


1. Encrypt your disks on your VPS, store the keys and passphrases on a server on premise. Your remote VPS can reboot with no user interaction as long as your on premise server hosting the keys is up.
2. Store the key file and passphrase file on two different remote systems if you like. Both systems must be up for your disks to be successfully decrypted.
3. Encrypt the keys on the remote system so they can be stored on untrusted systems.

## How to Install:

1. Copy the geliunlock script to /usr/local/etc/rc.d/
```
fetch https://raw.githubusercontent.com/clinta/geliUnlocker/master/unlockgeli /usr/local/etc/rc.d/
chmod +x /usr/local/etc/rc.d/unlockgeli
```

## How to Use:

You need an account on a remote system with scp access via public key authentication using a key with no passphrase. If doing this on a vps, you might want to consider creating a user just for this purpose and restricting their login schell to scp only.

The private key for ssh authentication to the remove server must be stored somehwere that is not on one of your encrypted disks.

If you want, encrypt your geli key and passphrase file using openssl (the -k parameter is your passphrase that you will add into rc.conf later):
```
openssl enc -aes-256-cbc -a -salt -in geli.key -out geli.key.aes -k "YTVCXmx2hBY69zoA7s6Gp886X3"
openssl enc -aes-256-cbc -a -salt -in geli.pw -out geli.pw.aes -k "NBRxX8rvZfOWfRYhMnnyfhCRO"
```

Copy your geli key file (or your encrypted keyfile if using encryption) to your remote host. Create a passphrase file (a text file containing your passphrase to your geli disk) and put it on the same, or a different remote host.

Configure your automatic decryption in rc.conf:
```
# If netwait is enabled, geliunlock will wait to run until the default gateway responds to ping to run.
netwait_enable="YES"

# Enable the unlockgeli script
unlockgeli_enable="YES"

# A list of groups of disks. These do not necessarily have to correspond to zfs pools, but they often will.
unlockgeli_pools="tank docs"

# Devices belonging to the pool listed above are defined here.
unlockgeli_tank_devs="/dev/da1 /dev/da2 /dev/gptid/96235f62-1074-11e4-a04d-50e549c81799"
# scp syntax path to the geli key file
unlockgeli_tank_key="bob@192.168.1.24:/home/bob/geli.key"
# the OpenSSL password chosen for encryption. If this is omitted, the key is assumed to not be encrypted.
unlockgeli_tank_key_enc_pw="YTVCXmx2hBY69zoA7s6Gp886X3"
# The ssh key file for this server
unlockgeli_tank_key_identityfile="/root/bob.id-rsa"
# scp syntax path to the geli passphrase file
unlockgeli_tank_passphrase="tom@192.168.1.53:/home/tom/geli.pw"
# the OpenSSL password chosen for encryption. If this is omitted, the key is assumed to not be encrypted.
unlockgeli_tank_passphrase_enc_pw="NBRxX8rvZfOWfRYhMnnyfhCRO"
# the ssh key file for this server
unlockgeli_tank_passphrase_identityfile="/root/tom.id-rsa"

```

At the end of the script `zfs mount -a` is called, so any zfs datasets on the newly decrypted disks should be mounted. Also this script will attempt to run before jail, so any jails stored on these encrypted volumes can run on boot.
