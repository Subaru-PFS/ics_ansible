#! /bin/sh

export ISO_IMAGE=$1
export KS_CFG=$2

# config
export ORIG_ISO='./iso_orig/'
export TEMP_ISO='./iso_temp/'

echo "Using original iso: $ISO_IMAGE"
echo "Using ks.cfg      : $KS_CFG"

if [ ! -e $ISO_IMAGE ]; then
    echo "Source iso image $ISO_IMAGE does not exist"
    exit
fi
if [ ! -e $KS_CFG ]; then
    echo "Source ks.cfg $KS_CFG does not exist"
    exit
fi
if [ -e $ORIG_ISO ]; then
    echo "Directory $ORIG_ISO exists."
    exit
fi
if [ -e $TEMP_ISO ]; then
    echo "Directory $TEMP_ISO exists."
    exit
fi

mkdir $ORIG_ISO $TEMP_ISO
sudo losetup -a
sudo mount -o loop $ISO_IMAGE $ORIG_ISO
rsync -a -H --exclude=TRANS.TBL $ORIG_ISO $TEMP_ISO
sudo umount $ORIG_ISO
rmdir $ORIG_ISO
chmod -R u+w $TEMP_ISO
cp $KS_CFG $TEMP_ISO/ks.cfg

mv $TEMP_ISO/isolinux/isolinux.cfg $TEMP_ISO/isolinux/isolinux.cfg.orig
cat << EOS > $TEMP_ISO/isolinux/isolinux.cfg
default install
prompt 0
timeout 3
label install
  menu label ^Install
  kernel vmlinuz
  append initrd=initrd.img ks=cdrom:/ks.cfg quiet
EOS

genisoimage -r -l -J -o $KS_CFG.iso \
    -quiet \
    -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table $TEMP_ISO

rm -Rf $TEMP_ISO

