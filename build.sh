#!/bin/sh

export LUA_PATH="/usr/local/lib/lua/5.1/luacov-cobertura/src/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/usr/share/lua/5.1//?.lua;/usr/share/lua/5.1//?/init.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;`pwd`/?.lua;`pwd`/src/?.lua;$LUA_PATH"
export LUA_CPATH="/usr/local/lib/lua/5.1/?.so;/root/.luarocks/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;$LUA_CPATH"

GAME_NAME="$1"
BUILD_NR="$2"
STUB_DIR=/var/lib/love/stubs

# Submodules auf aktuellen Stand bringen
/usr/bin/git submodule sync
/usr/bin/git submodule update

# Dokumentation
mkdir -p doc/
/usr/local/bin/luadoc -d doc src/

# Unit-Tests mit Code-coverage
/usr/local/bin/busted --output=TAP -c -v -p test_ Tests > 2dgame.tap

# Code-Coverage formatieren
/usr/local/bin/luacov-cobertura
rm luacov.stats.out
mv luacov.report.out coverage.txt

# Konvertiere markdown zu HTML.
echo "<html><head><title>Documentations</title></head><body>
<h1>Documentations</h1>
<ul>" > documents/index.html
for f in documents/*.md; do
  nf="documents/`basename $f .md`.html"
  /usr/bin/pandoc -f markdown -t html5 -o $nf $f
  echo "<li><a href=\"`basename $nf`\">`head -n1 $f | sed 's,^[ #]*,,; s,[ #]*$,,'`</a></li>" >> documents/index.html
done
echo "</body></html>" >> documents/index.html

# Erstelle binaries.
rm -rf bin 2> /dev/null
mkdir bin

# Stubs downloaden
/usr/local/bin/update-stubs

# Aktuelle love-Version feststellen
LOVE_VERSION=`${STUB_DIR}/fetch-current-version`

# Love datei erstellen
( cd src && zip -r ../bin/game.love . )

# Mac OS X APP erstellen und packen
unzip ${STUB_DIR}/love-${LOVE_VERSION}-macosx-x64.zip -d bin/
mv bin/love.app bin/${GAME_NAME}.app
cp bin/game.love bin/${GAME_NAME}.app/Contents/Resources/${GAME_NAME}.love
( cd bin && zip -r ${GAME_NAME}-${BUILD_NR}-macosx.zip ${GAME_NAME}.app )
rm -r bin/${GAME_NAME}.app

# Windows EXE erstellen und packen
for platform in win{64,32}; do
    unzip ${STUB_DIR}/love-${LOVE_VERSION}-${platform}.zip -d bin/
    cat bin/game.love >> bin/love-${LOVE_VERSION}-${platform}/love.exe
    ( cd bin && zip -r ${GAME_NAME}-${BUILD_NR}-${platform}.zip love-${LOVE_VERSION}-${platform} )
    rm -r bin/love-${LOVE_VERSION}-${platform}
done

# Ubuntu DEB packete erstellen.
for platform in {i386,amd64}; do
    mkdir bin/tmp
    cp ${STUB_DIR}/love_${LOVE_VERSION}ppa1_${platform}.deb bin/tmp/
    ( cd bin/tmp && ar -x love_${LOVE_VERSION}ppa1_${platform}.deb && unxz data.tar.xz && tar xf data.tar && rm data.tar && mkdir DEBIAN && mv control.tar.gz DEBIAN && cd DEBIAN && tar xfz control.tar.gz && rm control.tar.gz )
    rm bin/tmp/love_${LOVE_VERSION}ppa1_${platform}.deb
    sed -i "s/Package: love/Package: ${GAME_NAME}/g" bin/tmp/DEBIAN/control
    sed -i "s/Version: ${LOVE_VERSION}ppa1/Version: ${BUILD_NR}/g" bin/tmp/DEBIAN/control
    sed -i "s/Homepage: http:\/\/love2d\.org/Homepage: http:\/\/www.thi.de/g" bin/tmp/DEBIAN/control
    head -n -2 bin/tmp/DEBIAN/control > bin/tmp/DEBIAN/control.new
    echo "Description: Projekt INF/FFI SS 2016 - Based on LOVE 2D" >> bin/tmp/DEBIAN/control.new
    rm bin/tmp/DEBIAN/control && mv bin/tmp/DEBIAN/control.new bin/tmp/DEBIAN/control
    mv bin/tmp/usr/share/applications/love.desktop bin/tmp/usr/share/applications/${GAME_NAME}.desktop
    sed -i "s/love/${GAME_NAME}/g" bin/tmp/usr/share/applications/${GAME_NAME}.desktop
    cp src/assets/icon.svg bin/tmp/usr/share/pixmaps/${GAME_NAME}.svg
    rm bin/tmp/usr/share/pixmaps/love.svg
    cat bin/tmp/usr/bin/love bin/game.love > bin/tmp/usr/bin/${GAME_NAME}
    rm bin/tmp/usr/bin/love
    chmod +x bin/tmp/usr/bin/${GAME_NAME}
    dpkg-deb --build bin/tmp
    mv bin/tmp.deb bin/${GAME_NAME}-${BUILD_NR}-${platform}.deb
    rm -rf bin/tmp
done

# Android APK erstellen
rm -rf tmp 2> /dev/null
mkdir -p tmp 2> /dev/null
# mkdir -p tmp2 2> /dev/null
mkdir frmtmp 2> /dev/null
# unzip ${STUB_DIR}/love-${LOVE_VERSION}-android.apk -d tmp
/usr/local/bin/apktool d ${STUB_DIR}/love-${LOVE_VERSION}-android.apk -a /usr/local/bin/aapt -o tmp -f -p frmtmp
if [ ! -e tmp/assets ]; then
    mkdir tmp/assets
fi
cp bin/game.love tmp/assets/game.love
rm tmp/META-INF/*.SF 2> /dev/null
rm tmp/META-INF/*. 2> /dev/null
# update Mainfest-config
sed -i 's/LÖVE for Android/S.H.I.T/g' tmp/AndroidManifest.xml
sed -i 's/@drawable\/love/@drawable\/shit/g' tmp/AndroidManifest.xml
sed -i 's/screenOrientation="landscape"/screenOrientation="portrait"/g' tmp/AndroidManifest.xml
# create iconset
/usr/bin/convert -resize 48x48 -background none src/assets/icon/hamster.svg tmp/res/drawable-mdpi-v4/shit.png
/usr/bin/convert -resize 72x72 -background none src/assets/icon/hamster.svg tmp/res/drawable-hdpi-v4/shit.png
/usr/bin/convert -resize 96x96 -background none src/assets/icon/hamster.svg tmp/res/drawable-xhdpi-v4/shit.png
/usr/bin/convert -resize 144x144 -background none src/assets/icon/hamster.svg tmp/res/drawable-xxhdpi-v4/shit.png
/usr/bin/convert -resize 192x192 -background none src/assets/icon/hamster.svg tmp/res/drawable-xxxhdpi-v4/shit.png
cat tmp/AndroidManifest.xml
/usr/local/bin/apktool b tmp -o bin/${GAME_NAME}-${BUILD_NR}-android.apk -a /usr/bin/aapt -p frmtmp
rm -rf tmp frmtmp
${JAVA_HOME}/bin/jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore util/android.keystore -storepass NeverGonnaGiveYouUp -keypass LetYouDown bin/${GAME_NAME}-${BUILD_NR}-android.apk ${GAME_NAME}
