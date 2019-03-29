
RTL_FOLDER="../../rtl/"

for file in "$RTL_FOLDER"/*
do
		node vhdlBeautify.js $file
done
