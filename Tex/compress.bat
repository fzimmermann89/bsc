gs -o compressed.pdf -sDEVICE=pdfwrite -sProcessColorModel=DeviceCMYK -sColorConversionStrategy=CMYK -sColorConversionStrategyForImages=CMYK -dPDFSETTINGS=/prepress -dNOPAUSE -dBATCH main.pdf
rm main.pdf
mv compressed.pdf main.pdf