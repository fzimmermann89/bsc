gs -o compressed.pdf -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dNOPAUSE -dBATCH main.pdf
rm main.pdf
mv compressed.pdf main.pdf
