@echo off
echo Starting lernOS Guide Generation ...

REM Required Software
REM See lernOS Core Repository

REM Variables
set filename="lernOS-Community-Management-Guide-de"
set chapters=./src/index.md ./src/1-00-Bevor_ihr_loslegt.md ./src/2-01-Communities_und_Organisationsstrukturen.md ./src/2-02-Definitionen.md ./src/2-03-Community-Rollen.md ./src/2-04-Community_Lifecycle.md ./src/3-00-Community-Fallbeispiele.md ./src/4-00-Die_Community_aufbauen_managen_und_weiterentwickeln.md ./src/4-01-Als_Team_starten.md ./src/4-02-Konzeption_und_Planung.md ./src/4-03-Community_aktivieren_und_fuehren.md ./src/4-04-Community_transformieren_oder_schliessen.md ./src/5-00-Lernpfad.md ./src/6-00-Anhang.md

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
rem __ORIG__
pandoc metadata.yaml --from markdown --resource-path="./src" --template lernOS --number-sections -V lang=de-de %chapters% -o %filename%.pdf
rem _CreateLog_ pandoc --verbose metadata.yaml --from markdown --resource-path="./src" --template lernOS --number-sections -V lang=de-de %chapters% -o %filename%.pdf 2>C:\Users\haral\Downloads\pandoc.log

rem __Hardy's trials__ 
rem   pandoc --verbose --pdf-engine=xelatex metadata.yaml --from markdown --resource-path="./src" --template lernOS --number-sections -V lang=de-de %chapters% -o %filename%.pdf 2>C:\Users\haral\Downloads\pandoc.log

REM Create eBook Versions (epub, mobi)
rem       echo Creating eBook versions ...
rem       magick -density 300 %filename%.pdf[0] src/images/ebook-cover.jpg
rem       magick mogrify -size 2500x2500 -resize 2500x2500 src/images/ebook-cover.jpg
rem       magick mogrify -crop 1563x2500+102+0 src/images/ebook-cover.jpg
rem       pandoc metadata.yaml -s --resource-path="./src" --epub-cover-image=src/images/ebook-cover.jpg %chapters% -o %filename%.epub
rem       ebook-convert %filename%.epub %filename%.mobi

echo Done. Check for error messages or warnings above. 

pause