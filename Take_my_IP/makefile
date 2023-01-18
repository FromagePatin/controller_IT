# Project name is use to generate the pdf output
PRJ_NAME=Take_my_ip

SOURCE = main
OUT_DIR = ./temp
LATEX_CMD = latex -output-format='pdf' -output-directory=$(OUT_DIR) $(SOURCE).tex

draw_src = $(shell find ./draw -type f -name "*.draw.svg")
draw_target = $(draw_src:./draw/%.draw.svg=./figure/%.draw.png)

# drawio_src = $(shell find ./draw -type f -name "*.drawio.svg")
# drawio_target = $(drawio_src:./draw/%.drawio.svg=./figure/%.drawio.png)

# #https://unix.stackexchange.com/questions/140912/no-target-error-using-make


# Need install "latex" and "texlive-bibtex-extra"
./$(OUT_DIR)/$(SOURCE).aux: *.tex ./texContent/* $(draw_target) makefile
	if [ ! -d "temp/" ]; then mkdir temp;  mkdir temp/texContent; fi
	$(LATEX_CMD)
	bibtex ./$(OUT_DIR)/$(SOURCE)
# https://www.dickimaw-books.com/software/bib2gls/
# bug need java
	bib2gls ./$(OUT_DIR)/$(SOURCE)
#	$(LATEX_CMD)
#	$(LATEX_CMD)
	mv ./temp/main.pdf ./$(PRJ_NAME).pdf

# generate png from drawio
#	Input svg file, <name>.drawio.svg
#	Output png file, <name>.drawio.png
#./figure/%.drawio.png: ./drawio/%.drawio.svg
#	inkscape --export-area-drawing --export-dpi=300 --export-png=./$@ $<
#	drawio -x -f png --quality=100 -o $@ $<

# generate png from svg
#	Input svg file, <name>.draw.svg
#	Output png file, <name>.draw.png
#./figure/%.draw.png: ./draw/%.draw.svg
# for old inkscape version
#	inkscape --export-area-drawing --export-dpi=300 --export-png=./$@ $< 
# for new inkscape version
#	inkscape --export-area-drawing --export-dpi=300 --export-type=png --export-filename=$(PWD)/$@ $(PWD)/$< 


clean:
	find . -name '*.aux' -delete

reset:
	make clean
	rm -f $(SOURCE).pdf
	rm -R -f temp

# Copy the current version of the report at the root of the project
release:
	make
# For a release, it is recommended to compile thrice (for labels and references)
	$(LATEX_CMD)
	$(LATEX_CMD)
	mv ./temp/main.pdf ./$(PRJ_NAME).pdf
	cp -f ./$(PRJ_NAME).pdf ../