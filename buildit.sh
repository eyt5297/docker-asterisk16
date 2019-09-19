#!/usr/bin/env bash

TARGET_DIR="/tmp/src"

echo "Installing packages"
yum install -y \
  bzip2 \
  cronie \
  cronie-anacron \
  crontabs \
  epel-release \
  ghostscript \
  git \
  lame \
  libtiff-tools \
  libtool \
  net-tools \
  patch \
  psmisc \
  sox \
  tmux \
  vim \
  wget \
  gcc \
  gcc-c++ \
  automake \
  audiofile-devel \
  gmime-devel \
  gnutls-devel \
  gtk2-devel \
  kernel-devel \
  libcurl-devel \
  libtermcap-devel \
  libtiff-devel \
  libuuid-devel \
  libxml2-devel \
  ncurses-devel \
  neon-devel \
  newt-devel \
  openssl-devel \
  sqlite-devel \
  libedit-devel \
  tree \
  mc \
  uuid-devel

mkdir $TARGET_DIR && cd $TARGET_DIR

echo "Getting source"
wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz

echo "Extracting source"
tar xzf asterisk*
cd asterisk-16.*

echo "Configure..."
./configure --with-jansson-bundled --with-pjproject-bundled --libdir=/usr/lib64

echo "====4 pjsua build"
sed -i '67d' ./third-party/pjproject/Makefile
sed -i '60d' ./third-party/pjproject/Makefile
#sed -i 's/--disable-g711-codec//' ./third-party/pjproject/Makefile.rules
cd ./third-party/pjproject/source/
./aconfigure -q --prefix=/opt/pjproject --disable-speex-codec --disable-speex-aec --disable-bcg729 --disable-gsm-codec --disable-ilbc-codec --disable-l16-codec --disable-g722-codec --disable-g7221-codec --disable-opencore-amr --disable-silk --disable-opus --disable-video --disable-v4l2 --disable-sound --disable-ext-sound --disable-sdl --disable-libyuv --disable-ffmpeg --disable-openh264 --disable-ipp --disable-libwebrtc --without-external-pa --without-external-srtp --disable-resample --enable-epoll
cd ../../..

echo "Building menuselect"
make menuselect.makeopts
menuselect/menuselect --enable app_mp3  --enable func_pitchshift --enable app_chanisavail --enable chan_sip --enable res_fax_spandsp --enable cdr_csv --enable CORE-SOUNDS-RU-WAV --enable CORE-SOUNDS-RU-GSM \
    --disable CORE-SOUNDS-EN-WAV --enable CORE-SOUNDS-EN-GSM \
    --disable-category MENUSELECT_ADDONS \
    --disable-category MENUSELECT_EXTRA_SOUNDS \
    --disable-category MENUSELECT_AGIS \
    --disable-category MENUSELECT_TESTS \
    --enable res_hep \
    --enable res_hep_pjsip \
    --enable res_hep_rtcp \
   --enable res_statsd \
    menuselect.makeopts

echo "Make"
make

echo "Install"
cp ./third-party/pjproject/source/pjsip-apps/bin/pjsua-x86_64-unknown-linux-gnu /usr/sbin/pjsua
make install
make config
make basic-pbx

echo "Clean"

cd /
rm -rf /tmp/*


yum remove -y \
automake \
gcc \
gcc-c++  \
audiofile-devel \
gmime-devel \
gnutls-devel \
gtk2-devel \
kernel-devel \
libcurl-devel \
libedit-devel \
libtermcap-devel \
libtiff-devel \
libuuid-devel \
libxml2-devel \
ncurses-devel \
neon-devel \
newt-devel \
openssl-devel \
patch \
sqlite-devel \
uuid-devel

yum autoremove -y && yum clean all

