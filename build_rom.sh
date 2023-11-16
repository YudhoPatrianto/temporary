# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/HorizonDroidLab/manifest.git -b fourteen
git clone https://github.com/YudhoPatrianto/local_manifests.git --depth 1 -b HorizonDroid .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
. build/envsetup.sh
lunch aosp_selene-userdebug
export KBUILD_BUILD_USER=YudhoPRJKT
export KBUILD_BUILD_HOST=RvLProMaster
export BUILD_USERNAME=$KBUILD_BUILD_USER
export BUILD_HOSTNAME=$KBUILD_BUILD_HOST
export TZ=Asia/Jakarta #put before last build command
make bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
