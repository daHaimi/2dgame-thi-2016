#!/bin/sh

export LUA_PATH="/usr/local/lib/lua/5.1/luacov-cobertura/src/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/usr/share/lua/5.1//?.lua;/usr/share/lua/5.1//?/init.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;`pwd`/?.lua;`pwd`/src/?.lua;$LUA_PATH"
export LUA_CPATH="/usr/local/lib/lua/5.1/?.so;/root/.luarocks/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;$LUA_CPATH"

GAME_NAME="$1"
BUILD_NR="$2"
STUB_DIR=/var/lib/love/stubs

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
    cp ${STUB_DIR}/love_${LOVE_VERSION}ppa1_${platform}.deb bin/tmp
    ( cd bin/tmp && ar -x love_${LOVE_VERSION}ppa1_${platform}.deb && unxz data.tar.xz && tar xf data.tar \\
        && mkdir DEBIAN && mv control.tar.gz DEBIAN && cd DEBIAN && tar xfz control.tar.gz )
    rm bin/love_${LOVE_VERSION}ppa1_${platform}.deb
    cat bin/tmp/usr/bin/love bin/game.love > bin/tmp/usr/bin/${GAME_NAME}
    chmod +x bin/tmp/usr/bin/${GAME_NAME}
    dpkg-deb --build bin/tmp
    mv bin/tmp.deb bin/${GAME_NAME}-${platform}.deb
done

# Android APK erstellen
#rm -rf tmp 2> /dev/null
#unzip stubs/android/stub.apk -d tmp
#cp bin/game.love tmp/assets/game.love
#rm tmp/META-INF/*.SF
#rm tmp/META-INF/*.RSA
#( cd tmp && zip -r ../bin/android.apk . )
#rm -r tmp
#${JAVA_HOME}/bin/jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore stubs/android/keystore -storepass BannnanasGrowOnTreees -keypass MunkeyysMustThereforeDigDeeep bin/android.apk 2dgame
