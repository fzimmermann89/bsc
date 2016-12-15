gs -o compressed.pdf -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress  -dColorConversionStrategy=/LeaveColorUnchanged  -dDownsampleColorImages=false -dEmbedAllFonts=true  -dCompressFonts=true -dSubsetFonts=false -dNOPAUSE -dBATCH main.pdf
rm main.pdf
mv compressed.pdf main.pdf