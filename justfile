TEXMK := "latexmk"
TEXOUTDIR := "latex.out"
TEXFLAGS := "-pdflua -output-directory=" + TEXOUTDIR

_default:
    @just --list

[private]
pdf basename:
    {{ TEXMK }} {{ TEXFLAGS }} {{ basename }}.tex
    @cp {{ TEXOUTDIR }}/{{ basename }}.pdf .

[doc("Compile templates")]
template:
    @just pdf msca-pf-part-b1-template
    @just pdf msca-pf-part-b2-template

[doc("Check for typos (using typos)")]
typos:
    typos --sort --files --config typos.toml
    @echo -e "\e[1;32mtypos clean!\e[0m"

[doc("Update license text")]
license:
    python -m reuse download CC0-1.0
    cp LICENSES/CC0-1.0.txt LICENSE
    @rm -rf LICENSES

[doc("Remove all temporary compilation files")]
clean:
    rm -rf {{ TEXOUTDIR }}

[doc("Remove all generated files")]
purge: clean
    rm -rf *.pdf
