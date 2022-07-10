#!/bin/bash

git clone "https://github.com/coolsnowwolf/lede.git"

pushd "lede"; 

git reset --hard b8c1f2d824db114a7e5289bbbfd9b8fa86354747
sed -i -e 's/192.168.1.1/192.168.123.1/g' -e 's/OpenWrt/TPLink_WR703Nv1/g' package/base-files/files/bin/config_generate  #修改路由器管理IP地址和主机名
# sed -i '343s/4/16/g' target/linux/ar71xx/image/tiny-tp-link.mk  #修改wr703nv1的编译固件大小
rm -rf target/linux/ath79/image/tiny-tp-link.mk
rm -rf target/linux/ath79/dts/ar9331_tplink_tl-wr703n_tl-mr10u.dtsi
wget https://am.sohaha.xyz/tp703/tiny-tp-link.mk -O target/linux/ath79/image/tiny-tp-link.mk
wget https://am.sohaha.xyz/tp703/ar9331_tplink_tl-wr703n_tl-mr10u.dtsi -O target/linux/ath79/dts/ar9331_tplink_tl-wr703n_tl-mr10u.dtsi
sed -i -e 's/OpenWrt/TPLink_WR703Nv1/g' -e 's/encryption=none/encryption=psk2/g' -e '/psk2/a\			set wireless.default_radio${devidx}.key=password' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改WiFi名称,添加加密方式和密码

# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default                                      #使用源码自带ShadowSocksR Plus软件
sed -i -e '1s/$/^f6caa0a/g' feeds.conf.default
sed -i -e '2s/$/^ff4b0f6/g' feeds.conf.default
sed -i -e '3s/$/^e352557/g' feeds.conf.default
sed -i -e '4s/$/^02d5dc5/g' feeds.conf.default
echo 'src-git helloworld https://github.com/fw876/helloworld.git^0b25484' >>feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >>feeds.conf.default

./scripts/feeds update -a -f
./scripts/feeds install -a -f
./scripts/feeds update -a
./scripts/feeds install -a

popd
