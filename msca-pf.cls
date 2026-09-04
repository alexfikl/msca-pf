% <<< preamble

\def\mscaversion{5.0}
\def\fileversion{v2026.5}
\def\filedate{2026/09/04}
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

% enable tagging features if \DocumentMetadata was used
\newif\if@tagged \@taggedfalse
\ifdefined\IfDocumentMetadataTF
    \IfDocumentMetadataTF{\@taggedtrue}{\@taggedfalse}
\fi

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

% <<< tagging

% warn about tagging before we start
\if@tagged
    \ifluatex\else
        \PackageWarning{msca-pf}{Tagged PDF generation is not fully supported with pdfLaTeX and will not currently produce veraPDF-clean PDF/UA-2 output. Compile with LuaLaTeX (TeX Live 2025+) for tagged PDFs}
    \fi
\fi

% provide the tagging commands used by the class.
\ifdefined\tagpdfstructbegin
    \let\tagstructbegin\tagpdfstructbegin
    \let\tagstructend\tagpdfstructend
\fi
\providecommand{\tagstructbegin}[1]{}
\providecommand{\tagstructend}{}

% custom roles
\if@tagged
    \tagpdfsetup{
        role/new-tag = {tag=msca-pf-comment, role=Div},
        role/new-tag = {tag=msca-pf-cvitem, role=Div},
        role/new-tag = {tag=msca-pf-org-overview, role=Div},
        role/new-tag = {tag=msca-pf-org-capacity, role=Div},
    }
\fi

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
    % NOTE: lineno is not compatible with tagging, but this is just meant for
    % drafting, not the final document, so it should be fine for now
    \RequirePackage[mathlines]{lineno}
    \RenewDocumentCommand \linenumberfont {} {
        \normalfont\footnotesize\textcolor{black!50}
    }
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
        \linenumbers
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
% NOTE: this is uglier, but seems to work with tagging (which KOMA-Script does not support)
\renewcommand\section{\@startsection{section}{1}{\z@}{0.5em}{0.5em}{\large\bfseries\itshape}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}{0.5em}{0.5em}{\normalsize\bfseries\itshape}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}{0.25em}{0.25em}{\normalsize\bfseries\itshape}}

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
    {\huge \bfseries
        \tagstructbegin{tag=Title}
        \@title \par
        \tagstructend}
    \vspace{\baselineskip}
}

% >>>

% <<< comments

\if@draftproposal
    \newenvironment{mscaexplanation}{
        \tagstructbegin{tag=msca-pf-comment}%
        \begingroup
    }{
        \endgroup
        \tagstructend
    }
\else
    \newenvironment{mscaexplanation}{\setbox\z@\vbox\bgroup}{\egroup}
\fi

% >>>

% <<< table

\NewDocumentCommand \ra {} {\raggedright\arraybackslash}

\newlength{\tablewidth}

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
\tagstructbegin{tag=msca-pf-org-overview}
\if@tagged\tagpdfsetup{table/tagging=true, table/header-rows={1}}\fi
\setlength{\tablewidth}{\dimexpr\textwidth - 12\tabcolsep - 7\arrayrulewidth\relax}
\begin{msctable}{
    |>{\ra}p{0.15\tablewidth}
    |>{\ra}p{0.12\tablewidth}
    |>{\ra}p{0.25\tablewidth}
    |>{\ra}p{0.14\tablewidth}
    |>{\ra}p{0.15\tablewidth}
    |>{\ra}p{0.19\tablewidth}|}
\hline
\rowcolor{gray!40}
\centering\arraybackslash \textbf{Organisation Role} &
\centering\arraybackslash \textbf{PIC} &
\centering\arraybackslash \textbf{Legal Entity Short Name} &
\centering\arraybackslash \textbf{Academic Organisation (Y/N)} &
\centering\arraybackslash \textbf{Country} &
\centering\arraybackslash \textbf{Name of Supervisor} \\\hline
}{
\hline
\end{msctable}
\tagstructend
}

% NOTE: This can contain a lot of text, so we make it long by default
\newenvironment{mscaorgcapacity}{
\tagstructbegin{tag=msca-pf-org-capacity}
\if@tagged\tagpdfsetup{table/tagging=true, table/header-columns={1}}\fi
\setlength{\tablewidth}{\dimexpr\textwidth - 4\tabcolsep - 3\arrayrulewidth\relax}
\begin{msclongtable}{
    |>{\ra}p{0.3\tablewidth}
    |>{\ra}p{0.7\tablewidth}|}
\hline
}{
\hline
\end{msclongtable}
\tagstructend
}

% >>>

% <<< cv

\newenvironment{cvitem}{
\tagstructbegin{tag=msca-pf-cvitem}
\if@tagged\tagpdfsetup{table/tagging=presentation}\fi
\setlength{\tablewidth}{\dimexpr\textwidth - 4\tabcolsep\relax}
\noindent \begin{tabular}{@{}>{\ra}p{0.18\tablewidth}>{\ra}p{0.82\tablewidth}}
}{
\end{tabular}
\tagstructend
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
