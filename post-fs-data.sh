#!/system/bin/sh

MODDIR=${0%/*}
# addon.d
SLOT=$(resetprop -n ro.boot.slot_suffix)
if [ -d /system/addon.d ]; then
  log -t Magisk "- Adding addon.d survival script"
  blockdev --setrw /dev/block/mapper/system$SLOT 2>/dev/null || true
  blockdev --setrw /dev/block/by-name/system$SLOT 2>/dev/null || true
  REMOUNTED=""
  if mount | grep ' /system ' | grep -q 'ro'; then
    mount -o remount,rw /system
    REMOUNTED="/system"
  elif mount | grep ' / ' | grep -q 'ro'; then
    mount -o remount,rw /
    REMOUNTED="/"
  fi
  ADDOND=/system/addon.d
  cp -af $MODDIR/addon.d.sh $ADDOND/99-magisk.sh
  cp -af /data/adb/magisk $ADDOND/magisk
  chmod 755 $ADDOND/99-magisk.sh
  chmod 755 $ADDOND/magisk
  [ -n "$REMOUNTED" ] && mount -o remount,ro $REMOUNTED || true
fi