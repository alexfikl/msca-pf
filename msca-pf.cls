% <<< preamble

\def\mscaversion{5.0}
\def\fileversion{v\mscaversion}
\def\filedate{2026/08/07}
\def\clsname{msca-pf}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{\clsname}[\filedate\ \fileversion\ MSCA Proposal]

% >>>

% <<< declare options

% draft features
\newif\if@draftproposal \@draftproposalfalse
\DeclareOption{draftproposal}{\@draftproposaltrue}

% grid
\newif\if@layoutgrid \@layoutgridfalse
\DeclareOption{layoutgrid}{\@layoutgridtrue}

% minimal margins and fonts
\newif\if@minimal \@minimalfalse
\DeclareOption{minimal}{\@minimaltrue}

% enable tagging features
\newif\if@tagged \@taggedfalse
\DeclareOption{tagged}{\@taggedtrue}

% additional options passed to `scrartcl` class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\PassOptionsToClass{DIV=15,12pt,a4paper,parskip=half*}{scrartcl}

\ProcessOptions
\LoadClass{scrartcl}

% >>>

% <<< required packages

% NOTE: load packages after the class was loaded since they may depend on it

\RequirePackage{iftex}
\RequirePackage{xparse}
\RequirePackage[hypertexnames=false,breaklinks=true]{hyperref}
\RequirePackage{bookmark}

% build fancy table required for organization description
\RequirePackage{array}
\RequirePackage[table]{xcolor}
\RequirePackage{longtable}
% customize page numbering
\RequirePackage{lastpage}
% customize headers and footers
\RequirePackage{scrlayer-scrpage}

% >>>

% <<< process options

\if@draftproposal
    \newcount\timehh
    \timehh=\time \divide\timehh by 60
    \newcount\timemm
    \timemm=\time \count255=\timehh \multiply\count255 by -60 \advance\timemm by \count255

    \def\draftheader{
        \textit{Draft of \today\ at
        \ifnum\timehh<10 0\fi\number\timehh
        \,:\,%
        \ifnum\timemm<10 0\fi\number\timemm}}
\else
    \def\draftheader{\empty}
\fi

% add line numbers if in draft mode
\if@draftproposal
    \if@tagged
        \RequirePackage{lualineno}
    \else
        \RequirePackage[mathlines]{lineno}
        \RenewDocumentCommand \linenumberfont {} {
            \normalfont\footnotesize\textcolor{black!50}
        }
    \fi
\fi

% enable this to better check sizing
\if@layoutgrid
    \RequirePackage[
        grid, gridBG,
        gridunit=mm,
        gridcolor=gray!70,
        subgridcolor=gray!70,
        texcoord]{eso-pic}
    \usepackage{showframe}
\fi

% force minimal page requirements
\if@minimal
    \KOMAoptions{fontsize=11pt}
    \usepackage[
        top=15mm,
        bottom=15mm,
        left=15mm,
        right=15mm,
        headsep=2mm,
        footskip=16mm,
        includefoot,
    ]{geometry}
\fi

\AtBeginDocument{
    % customize PDF bookmarks a bit
    \bookmarksetup{numbered}

    \if@draftproposal
        \if@tagged
            % NOTE: for information on how to set this up for tagging see
            % https://mirrors.nxthost.com/ctan/macros/luatex/generic/lualineno/lualineno-doc.pdf
            \newcounter{lineno}
            \lualineno{
                define = {
                    name = default
                    toks = {\stepcounter{lineno}}
                    left = {\SuspendTagging{lineno}\normalfont\footnotesize\textcolor{black!50}{\thelineno}\kern1em\ResumeTagging{lineno}}
                }
                set = default
            }
        \else
            \linenumbers
        \fi
    \fi
}

% >>>

% <<< general formatting

\definecolor{MSCAHeaderGray}{RGB}{180, 180, 180}

% make links a bit less intrusive
\hypersetup{
    colorlinks=true,
    urlcolor=blue,
    citecolor=black,
    linkcolor=black
}

% required font is Times New Roman (or Nimbus Roman on Linux)
\ifpdftex
    \RequirePackage[T1]{fontenc}
    \RequirePackage{newtxtext}
    \RequirePackage{newtxmath}
    \RequirePackage{helvet}
\else
    \RequirePackage{fontspec}
    \IfFontExistsTF{Times New Roman}{
        \setmainfont[Ligatures={TeX,Historic},Renderer=Basic]{Times New Roman}}{
        \IfFontExistsTF{Nimbus Roman}{
            \setmainfont{Nimbus Roman}
        }{\PackageWarning{msca-pf}{Serif font not found: Times New Roman or Nimbus Roman}}}
    \IfFontExistsTF{Arial}{
        \setsansfont[Ligatures=TeX]{Arial}}{
        \IfFontExistsTF{Nimbus Sans}{
            \setsansfont[Ligatures=TeX]{Nimbus Sans}
        }{\PackageWarning{msca-pf}{Sans serif font not found: Arial or Nimbus Sans}}}
\fi

% force serif fonts
\addtokomafont{disposition}{\rmfamily}

% tighted sections a bit for more space
\RedeclareSectionCommand[beforeskip=0.5em, afterskip=0.5em, font=\large\bfseries\itshape]{section}
\RedeclareSectionCommand[beforeskip=0.5em, afterskip=0.5em, font=\normalsize\bfseries\itshape]{subsection}
\RedeclareSectionCommand[beforeskip=0.25em, afterskip=0.25em, font=\normalsize\bfseries\itshape]{subsubsection}

% FIXME: this is a bit of a hack, figure out a better place to put them
\setlength{\footskip}{25pt}
\setlength{\textheight}{\dimexpr\textheight+4em}

% >>>

% <<< page header/footer styles

\NewDocumentCommand \mscaidentifier { m } {\def\@mscaidentifier{#1}}
\NewDocumentCommand \mscaproject { m } {\def\@mscaproject{#1}}

\def\@mscaidentifier{HORIZON-MSCA-2026-PF-01}
\def\@mscaproject{MSCA Postdoctoral Fellowships 2026}

\def\callihead{\textnormal{\scriptsize Call: \@mscaidentifier: \@mscaproject}\vspace{\baselineskip}}
\def\callohead{\textnormal{\scriptsize \textcolor{MSCAHeaderGray}{
    EU Grants: Application form (HE MSCA PF) V\mscaversion \\
    \draftheader
    }
}}
\def\pagefooter{\textnormal{Part B -- Page \thepage\, of\, \pageref*{LastPage}}}

\clearpairofpagestyles
\pagestyle{scrheadings}

\cfoot[\pagefooter]{\pagefooter}
\ihead[\callihead]{\callihead}
\ohead[\callohead]{\callohead}

% >>>

% <<< title

\def\@maketitle{
    \null
    \centering
    \vspace{-\baselineskip}
    {\huge \bfseries \@title \par}
    \vspace{\baselineskip}
}

% >>>

% <<< comments

\if@draftproposal
    \newenvironment{mscaexplanation}{
        \begingroup
    }{
        \endgroup
    }
\else
    \newenvironment{mscaexplanation}{\setbox\z@\vbox\bgroup}{\egroup}
\fi

% >>>

% <<< table

\NewDocumentCommand \ra {} {\raggedright\arraybackslash}

\newenvironment{msctable}[1]{
\centering
\footnotesize
\begin{tabular}{#1}
}{%
\end{tabular}
}

\newenvironment{msclongtable}[1]{
\centering
\small
\begin{longtable}{#1}
}{%
\end{longtable}
}

\newenvironment{mscaorgoverview}{
\if@tagged\tagpdfsetup{table/tagging=true, table/header-rows={1}}\fi
\begin{msctable}{
    |>{\ra}p{0.165\linewidth}
    |>{\ra}p{0.075\linewidth}
    |>{\ra}p{0.15\linewidth}
    |>{\ra}p{0.15\linewidth}
    |>{\ra}p{0.15\linewidth}
    |>{\ra}p{0.15\linewidth}|}
\hline
\rowcolor{gray!40}
\textbf{Organisation Role} &
\textbf{PIC} &
\textbf{Legal Entity Short Name} &
\textbf{Academic Organisation (Y/N)} &
\textbf{Country} &
\textbf{Name of Supervisor} \\\hline
}{
\hline
\end{msctable}
}

% NOTE: This can contain a lot of text, so we make it long by default
\newenvironment{mscaorgcapacity}{
\if@tagged\tagpdfsetup{table/tagging=true, table/header-columns={1}}\fi
\begin{msclongtable}{
    |>{\ra}p{0.3\linewidth}
    |>{\ra}p{0.646\linewidth}|}
\hline
}{
\hline
\end{msclongtable}
}

% >>>

% <<< cv

\newenvironment{cvitem}{
\if@tagged\tagpdfsetup{table/tagging=presentation}\fi
\noindent \begin{tabular}{@{}>{\ra}p{0.18\linewidth}>{\ra}p{0.8\linewidth}}
}{
\end{tabular}
}

% NOTE: \cventry{dates}{name}{details}{location}
\NewDocumentCommand \cventry { m m m m } {#1 & \textbf{#2}, \emph{#3}, #4. \\}
% NOTE: \cvdetail{name}{details}
\NewDocumentCommand \cvdetail { m m } {& \textbf{#1}: #2. \\}
% NOTE: \cvpub{date}{authors}{title}{journal etc}
\NewDocumentCommand \cvpub { m m m m } {#1 & #2, \emph{#3}, #4. \\}

\NewDocumentCommand \cvpubitem { m m m m } {%
\begin{cvitem}
\cvpub{#1}{#2}{#3}{#4}
\end{cvitem}
}

\NewDocumentCommand \cventryitem { m m m m } {%
\begin{cvitem}
\cventry{#1}{#2}{#3}{#4}
\end{cvitem}
}

% >>>

\endinput
