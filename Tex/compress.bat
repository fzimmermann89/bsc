gs -o compressed.pdf -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress  -dColorConversionStrategy=/LeaveColorUnchanged  -dDownsampleColorImages=false  -dNOPAUSE -dBATCH main.pdf
rm main.pdf
mv compressed.pdf main.pdf
