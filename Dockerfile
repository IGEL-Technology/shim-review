
FROM debian:trixie

RUN apt-get update -y

RUN apt-get install -y devscripts debhelper-compat gnu-efi openssl libelf-dev gcc-14 dos2unix xxd libefivar-dev sbsigntool pesign efivar git wget

RUN git clone https://github.com/IGEL-Technology/shim.git

RUN wget https://github.com/rhboot/shim/releases/download/16.1/shim-16.1.tar.bz2
RUN echo "46319cd228d8f2c06c744241c0f342412329a7c630436fce7f82cf6936b1d603  shim-16.1.tar.bz2" > SHA256SUM
RUN sha256sum -c < SHA256SUM

RUN tar xvf shim-16.1.tar.bz2

#prove common shim code base to upstream 16.1
RUN diff -x .git -x debian -x gnu-efi -u shim-16.1 shim

WORKDIR /shim
RUN debuild -i -us -uc -b

WORKDIR /

RUN mkdir -p /build/output
RUN cp /shim/shim*.efi /build/output/
RUN objdump -s -j .sbatlevel /build/output/shim*.efi
RUN objdump -j .sbat -s /build/output/shim*.efi
RUN sha256sum /build/output/*
