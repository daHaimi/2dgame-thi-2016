#!/bin/sh

export LUA_PATH="/usr/local/lib/lua/5.1/luacov-cobertura/src/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/usr/share/lua/5.1//?.lua;/usr/share/lua/5.1//?/init.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;`pwd`/?.lua;`pwd`/src/?.lua;$LUA_PATH"
export LUA_CPATH="/usr/local/lib/lua/5.1/?.so;/root/.luarocks/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;$LUA_CPATH"

GAME_NAME="$1"

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

# Love datei erstellen
( cd src && zip -r ../bin/game.love . )

# Mac OS X APP erstellen
cp bin/game.love stubs/macosx/${GAME_NAME}.app/Contents/Resources/${GAME_NAME}.love
( cd stubs/macosx && zip -r ../../bin/macosx.zip . )
rm stubs/macosx/${GAME_NAME}.app/Contents/Resources/${GAME_NAME}.love

# Windows EXE erstellen und packen
# amd64
cp stubs/windows/amd64/${GAME_NAME}/${GAME_NAME}.exe tmp
cat bin/game.love >> stubs/windows/amd64/${GAME_NAME}/${GAME_NAME}.exe
( cd stubs/windows/amd64 && zip -r ../../../bin/win64.zip . )
mv tmp stubs/windows/amd64/${GAME_NAME}/${GAME_NAME}.exe
# i386
cp stubs/windows/i386/${GAME_NAME}/${GAME_NAME}.exe tmp
cat bin/game.love >> stubs/windows/i386/${GAME_NAME}/${GAME_NAME}.exe
( cd stubs/windows/i386 && zip -r ../../../bin/win32.zip . )
mv tmp stubs/windows/i386/${GAME_NAME}/${GAME_NAME}.exe

# Ubuntu DEB packete erstellen.
# amd64
cat stubs/ubuntu/amd64/usr/bin/love bin/game.love > stubs/ubuntu/amd64/usr/bin/${GAME_NAME}
chmod +x stubs/ubuntu/amd64/usr/bin/${GAME_NAME}
dpkg-deb --build stubs/ubuntu/amd64
mv stubs/ubuntu/amd64.deb bin/${GAME_NAME}-amd64.deb
# i386
cat stubs/ubuntu/i386/usr/bin/love bin/game.love > stubs/ubuntu/i386/usr/bin/${GAME_NAME}
chmod +x stubs/ubuntu/i386/usr/bin/${GAME_NAME}
dpkg-deb --build stubs/ubuntu/i386
mv stubs/ubuntu/i386.deb bin/${GAME_NAME}-i386.deb

# Android APK erstellen
#rm -rf tmp 2> /dev/null
#unzip stubs/android/stub.apk -d tmp
#cp bin/game.love tmp/assets/game.love
#rm tmp/META-INF/*.SF
#rm tmp/META-INF/*.RSA
#( cd tmp && zip -r ../bin/android.apk . )
#rm -r tmp
#${JAVA_HOME}/bin/jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore stubs/android/keystore -storepass BannnanasGrowOnTreees -keypass MunkeyysMustThereforeDigDeeep bin/android.apk 2dgame
