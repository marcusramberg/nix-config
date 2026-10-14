# fjordxy Plymouth theme

Install:

    sudo cp -r fjordxy /usr/share/plymouth/themes/
    sudo plymouth-set-default-theme -R fjordxy   # Debian/Mobian: update-initramfs -u
    # postmarketOS: set the theme, then `mkinitfs`

Test without rebooting:

    sudo plymouthd --debug --tty=`tty`; sudo plymouth show-splash; sleep 10; sudo plymouth quit

Notes
- Assets are authored at 1080px width and scaled at load; portrait panels of any size work.
- Glitch, data rain and scan sweep run in the refresh callback (~50 fps). On very weak SoCs, lower NCOLS in fjordxy.script.
- Includes a minimal LUKS passphrase prompt so encrypted installs still boot.
