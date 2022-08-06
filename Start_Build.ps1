rm -r ./Build/
mkdir ./Build/

TypeWriter build --input=./IPC-Host/src/
TypeWriter build --input=./Wrappers/TypeWriter/src/ --branch=Main
TypeWriter build --input=./Wrappers/TypeWriter/src/ --branch=Bootstrap
cp -r ./.TypeWriter/Build/* ./Build/

mkdir ./Build/Temp/
cp -r ./Wrappers/NodeJs/openipc-node/* ./Build/Temp/
cp ./Wrappers/HtmlJs/index.js ./Build/Temp/ipclient.js
cd ./Build/Temp/
browserify ./ipclient.js -o ../OpenIPC-HtmlJs.js --plugin tinyify
cd ../../

rm -r ./Build/Temp/*
cp -r ./Wrappers/NodeJs/openipc-node/* ./Build/Temp/
rm -r ./Build/Temp/node_modules/
rm ./Build/Temp/.gitignore
rm ./Build/Temp/package-lock.json
Compress-Archive -Path ./Build/Temp/* -DestinationPath ./Build/OpenIPC-NodeJs.zip

rm -r ./Build/Temp/
