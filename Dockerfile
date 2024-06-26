
FROM debian:bookworm

RUN apt-get update -y

RUN apt-get install -y devscripts debhelper-compat gnu-efi openssl libelf-dev gcc-12 dos2unix xxd libefivar-dev sbsigntool pesign efivar git wget

RUN git clone https://github.com/IGEL-Technology/shim.git

RUN wget https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2
RUN echo "a79f0a9b89f3681ab384865b1a46ab3f79d88b11b4ca59aa040ab03fffae80a9  shim-15.8.tar.bz2" > SHA256SUM
RUN sha256sum -c < SHA256SUM

RUN tar xvf shim-15.8.tar.bz2

#prove common shim code base to upstream 15.8
RUN diff -x .git -x debian -x gnu-efi -u shim-15.8 shim

WORKDIR /shim
RUN debuild -i -us -uc -b

WORKDIR /

RUN mkdir -p /build/output
RUN cp /shim/shimx64.efi /build/output
RUN objdump -s -j .sbatlevel /build/output/shimx64.efi
RUN objdump -j .sbat -s /build/output/shimx64.efi
RUN sha256sum /build/output/*
