# LVM Cheatsheet

## Setup on new machine

Create physical volume, volume group and logical volumes:

```bash
# create new physical volume
pvcreate /dev/sda1
# create new volume group
vgcreate main /dev/sda1
# create new logical volume
lvcreate -L 100G main -n root-volume
lvcreate -L 100G main -n home-volume
```

Format new volumes:

```bash
mkfs.ext4 /dev/main/root-volume
mkfs.ext4 /dev/main/home-volume
```

Install package via arch-chroot:

```bash
pacman -S lvm2
```

Add hook to mkinitcpio conifg:

```conf
# file /etc/mkinitcpio.conf
HOOK=(... block lvm2 filesystems ...)
```

And run:

```bash
mkinitcpio -P
```

Add to grub default config:

```conf
# file /etc/default/grub
GRUB_PRELAD_MODULES="... lvm"
```

And run:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```


## Basic operations

List exists **pv**, **vg**, **lv**:

```bash
pvs # show physical volumes
vgs # show volume groups
lvs # show logical volume groups
```

Extending exists **lv**

```bash
# 115G new expected size (lvm skip command if new size less then old)
lvextend -L 115G main/home-volume

# if btrfs used (use mount point instead of partition name)
btrfs filesystem resize max /home

# if ext4 used (file system can be mounted)
resize2fs /dev/main/home-volume
```

