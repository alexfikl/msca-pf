TEXMK := "latexmk"
TEXOUTDIR := "latex.out"
TEXFLAGS := "-pdflua -output-directory=" + TEXOUTDIR

_default:
    @just --list

# {{{ pdf

[private]
pdf basename:
    {{ TEXMK }} {{ TEXFLAGS }} {{ basename }}.tex
    @cp {{ TEXOUTDIR }}/{{ basename }}.pdf .

[doc("Compile templates")]
template:
    @just pdf msca-pf-part-b1-template
    @just pdf msca-pf-part-b2-template

# }}}

# {{{ linting

[doc("Format source files")]
format: yamlfmt mdformat justfmt

[doc("Format tex files with badness")]
texfmt:
    badness format --wrap stable --math-wrap preserve --indent-width 4 \
        msca-pf-part-b1-template.tex \
        msca-pf-part-b2-template.tex
    @echo -e "\e[1;32mbadness clean!\e[0m"

[doc("Format YAML files with yamlfmt")]
yamlfmt:
    yamlfmt -gitignore_excludes .
    @echo -e "\e[1;32myamlfmt clean!\e[0m"

[doc("Format markdown files with mdformat")]
mdformat:
    python -m mdformat .
    @echo -e "\e[1;32mmdformat clean!\e[0m"

[doc("Run just --fmt over the justfile")]
justfmt:
    just --unstable --fmt
    @echo -e "\e[1;32mjust --fmt clean!\e[0m"

[doc("Run all linting checks over the source code")]
lint: typos badness

[doc("Check for typos (using typos)")]
typos:
    typos --sort --config typos.toml
    @echo -e "\e[1;32mtypos clean!\e[0m"

[doc("Lint using badness")]
badness:
    badness lint msca-pf-part-b1-template.tex msca-pf-part-b2-template.tex
    @echo -e "\e[1;32mbadness clean!\e[0m"

[private]
ua_check basename format:
    verapdf \
        --flavor ua2 --format {{ format }} --progress \
        {{ basename }}.pdf > {{ basename }}-pdf-ua-2.{{ format }}
    @echo -e "\e[1;32mGenerated '{{ basename }}-pdf-ua-2.{{ format }}'!\e[0m"

[doc("Check PDF/UA2 compliance with verapdf")]
ua format="html":
    @just ua_check msca-pf-part-b1-template {{ format }}
    @just ua_check msca-pf-part-b2-template {{ format }}

[private]
wcag_check basename format:
    verapdf --profile .WCAG-2-2-Complete-PDF20.xml --progress \
        --format {{ format }} {{ basename }}.pdf > {{ basename }}-wcag-2-2.{{ format }}
    @echo -e "\e[1;32mGenerated '{{ basename }}-wcag-2-2.{{ format }}'!\e[0m"

[doc("Check WCAG 2.2 compliance with verapdf")]
wcag format="html":
    curl -o .WCAG-2-2-Complete-PDF20.xml \
        'https://raw.githubusercontent.com/veraPDF/veraPDF-validation-profiles/refs/heads/integration/PDF_UA/WCAG-2-2-Complete-PDF20.xml'
    @just wcag_check msca-pf-part-b1-template {{ format }}
    @just wcag_check msca-pf-part-b2-template {{ format }}

# }}}

# {{{ develop

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

# }}}
