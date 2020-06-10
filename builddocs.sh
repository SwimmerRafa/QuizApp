rm -fR doc
rdoc -m README.rdoc -o doc -f hanna src/ README.rdoc
cp -R img doc/files
