@ECHO OFF
:Loop
IF "%1"=="" GOTO Continue
gs -o compressed.pdf -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress  -dColorConversionStrategy=/LeaveColorUnchanged  -dDownsampleColorImages=false -dEmbedAllFonts=true  -dCompressFonts=true -dSubsetFonts=false -dNOPAUSE -dBATCH %~f1
rm %~f1
mv compressed.pdf %~f1
SHIFT
GOTO Loop
:Continue