@echo off
echo Starting lernOS Guide Generation ...

REM Required Software
REM See lernOS Core Repository

REM Variables
set filename="lernOS-Community-Management-Guide-de"
set chapters=./src/index.md ./src/1-00-Bevor_ihr_loslegt.md ./src/2-01-Communities_und_Organisationsstrukturen.md ./src/2-02-Definitionen.md ./src/2-03-Community-Rollen.md ./src/2-04-Community-Lifecycle.md ./src/3-00-Community-Fallbeispiele.md ./src/4-00-Die_Community_aufbauen_managen_und_weiterentwickeln.md ./src/4-01-Als_Team_starten.md ./src/4-02-Konzeption_und_Planung.md ./src/4-03-Community_aktivieren_und_fuehren.md ./src/4-04-Community_transformieren_oder_schliessen.md ./src/5-00-Lernpfad.md ./src/6-00-Anhang.md

REM Delete Old Versions
echo Deleting old versions ...
del %filename%.docx %filename%.epub %filename%.mobi %filename%.html %filename%.pdf

REM Create Microsoft Word Version (docx)
echo Creating Word version ...
pandoc metadata.yaml -s --resource-path="./src" %chapters% -o %filename%.docx

REM Create HTML Version (html)
echo Creating HTML version ...
pandoc metadata.yaml -s --resource-path="./src" --toc %chapters% -o %filename%.html

REM Create Web Version (mkdocs)
echo Creating Web Version ...
python -m  mkdocs build

REM Create PDF Version (pdf)
echo Creating PDF version ...
rem ___ORIG from Template 
rem pandoc metadata.yaml --from markdown -s --resource-path="./src" --template lernOS --number-sections --toc -V lang=de-de -o %filename%.pdf %chapters%
rem ___ ohne --number-sections
pandoc metadata.yaml --from markdown -s --resource-path="./src" --template lernOS --number-sections --toc -V lang=de-de -o %filename%.pdf %chapters%

rem __verbose > logfile__ 
rem pandoc --verbose metadata.yaml --from markdown --resource-path="./src" --template lernOS --number-sections -V lang=de-de %chapters% -o %filename%.pdf 2>%USERPROFILE%\Downloads\pandoc.log

REM Create eBook Versions (epub, mobi)
echo Creating eBook versions ...
echo ... magick -density ...
magick -density 300 %filename%.pdf[0] src/images/ebook-cover.jpg
echo ... magick mogrify -size ...
magick mogrify -size 2500x2500 -resize 2500x2500 src/images/ebook-cover.jpg
echo ... magick mogrify -crop ...
magick mogrify -crop 1563x2500+102+0 src/images/ebook-cover.jpg

echo ... pandoc ...
rem ___ORIG from Template 
pandoc metadata.yaml -s --resource-path="./src" --epub-cover-image=src/images/ebook-cover.jpg --number-sections --toc -V lang=de-de -o %filename%.epub %chapters%
rem ___ ohne --number-sections
rem pandoc metadata.yaml -s --resource-path="./src" --epub-cover-image=src/images/ebook-cover.jpg --number-sections --toc -V lang=de-de -o %filename%.epub %chapters%

echo ... ebook-convert ...
rem ebook-convert %filename%.epub %filename%.mobi
ebook-convert %filename%.epub %filename%.mobi --use-auto-toc 

echo Done. Check for error messages or warnings above. 

pause