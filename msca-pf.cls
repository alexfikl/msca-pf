% <<< preamble

\def\mscaversion{4.1}
\def\fileversion{v\mscaversion}
\def\filedate{2025/04/28}
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

% additional options passed to `scrartcl` class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\PassOptionsToClass{DIV=14,11pt}{scrartcl}

% >>>

% <<< process options

\ProcessOptions
\LoadClass{scrartcl}

% force serif fonts
\addtokomafont{disposition}{\rmfamily}
% additional options
\KOMAoptions{
    paper=A4,
    parskip=half*,
}

% tighted sections a bit for more space
\RedeclareSectionCommand[beforeskip=0.5em, afterskip=0.5em, font=\large\bfseries\itshape]{section}
\RedeclareSectionCommand[beforeskip=0.5em, afterskip=0.5em, font=\normalsize\bfseries\itshape]{subsection}
\RedeclareSectionCommand[beforeskip=0.25em, afterskip=0.25em, font=\normalsize\bfseries\itshape]{subsubsection}

\if@draftproposal
    \newcount\timehh
    \timehh=\time \divide\timehh by 60
    \newcount\timemm
    \timemm=\time \count255=\timehh \multiply\count255 by -60 \advance\timemm by \count255
    \def\draftheader{
        \textit{Draft of \today\ at
        \ifnum\timehh<10 0\fi\number\timehh
        \,:\,%
        \ifnum\timemm<10 0\fi\number\timemm}\vspace{-1.75em}}
\else
    \def\draftheader{\empty\vspace{-1.85em}}
\fi

% >>>

% <<< required packages

% NOTE: load packages after the class was loaded since they may depend on it

\RequirePackage{iftex}
\RequirePackage{xparse}
\RequirePackage[hypertexnames=false,breaklinks=true]{hyperref}

% required font is Times New Roman (or Nimbus Roman on Linux)
\ifpdftex
    \RequirePackage[T1]{fontenc}
    \RequirePackage{mathptmx}
    \RequirePackage{helvet}
\else
    \RequirePackage{fontspec}
    \IfFontExistsTF{Times New Roman}{
        \setmainfont[Ligatures={TeX,Rare}]{Times New Roman}}{
        \IfFontExistsTF{Nimbus Roman}{
            \setmainfont{Nimbus Roman}
        }{\PackageWarning{msca-pf}{Serif font not found: Times New Roman or Nimbus Roman}}}
    \IfFontExistsTF{Arial}{
        \setsansfont[Ligatures=TeX]{Arial}}{
        \IfFontExistsTF{Nimbus Sans}{
            \setsansfont[Ligatures=TeX]{Nimbus Sans}
        }{\PackageWarning{msca-pf}{Sans serif font not found: Arial or Nimbus Sans}}}
\fi

% build fancy table required for organization description
\RequirePackage{array}
\RequirePackage[table]{xcolor}
\RequirePackage{longtable}
% customize page numbering
\RequirePackage{lastpage}
% customize headers and footers
\RequirePackage{scrlayer-scrpage}
% indent first paragraph in a section
\RequirePackage{indentfirst}

% enable this to better check sizing
\if@layoutgrid
    \RequirePackage[
        grid, gridBG,
        gridunit=mm,
        gridcolor=gray!70,
        subgridcolor=gray!70,
        texcoord]{eso-pic}
\fi

\AtBeginDocument{
    % customize PDF bookmarks a bit
    \RequirePackage{bookmark}
    \bookmarksetup{numbered}

    \if@draftproposal
        \linenumbers
    \fi
}

% make links a bit less intrusive
\hypersetup{
    colorlinks=true,
    urlcolor=blue,
    citecolor=black,
    linkcolor=black
}

% <<< other

\definecolor{MSCATagGray}{RGB}{180, 180, 180}
\NewDocumentCommand \mscatag { m } {\textcolor{MSCATagGray}{\normalfont\scriptsize\sffamily \#@#1@\#}}
\NewDocumentCommand \mscatagend { m } {\noindent \textcolor{MSCATagGray}{\normalfont\scriptsize\sffamily \#§#1§\#}}

% >>>

% >>>

% <<< main matter

% add line numbers if in draft mode
\if@draftproposal
    \RequirePackage[mathlines]{lineno}
    \RequirePackage{xcolor}
    \RenewDocumentCommand \linenumberfont {} {
        \normalfont\footnotesize\textcolor{black!50}
    }
\fi

% >>>

% <<< page header/footer styles

\NewDocumentCommand \mscaidentifier { m } {\def\@mscaidentifier{#1}}
\NewDocumentCommand \mscaproject { m } {\def\@mscaproject{#1}}

\def\@mscaidentifier{HORIZON-MSCA-2025-PF-01}
\def\@mscaproject{MSCA Postdoctoral Fellowships 2025}

\pagestyle{plain}
\clearpairofpagestyles

\def\callihead{\textnormal{\scriptsize Call: \@mscaidentifier: \@mscaproject}}
\def\callohead{\textnormal{\scriptsize \textcolor{MSCATagGray}{
    EU Grants: Application form (HE MSCA PF) V\mscaversion \\
    \draftheader
    }
}}
\def\pagefooter{\textnormal{Part B -- Page \thepage\, of\, \pageref*{LastPage}}}

\cfoot[\pagefooter]{\pagefooter}
\ihead[\callihead]{\callihead}
\ohead[\callohead]{\callohead}

% FIXME: this is a bit of a hack, figure out a better place to put them
\setlength{\footskip}{25pt}
\setlength{\textheight}{\dimexpr\textheight+4em}

% >>>

% <<< title

\makeatletter
\def\@maketitle{
\if@draftproposal\begin{nolinenumbers}\fi
{
    \null
    \centering
    \vspace{-1em}
    {\huge \bfseries \@title \par}
    \vspace{1em}
}
\if@draftproposal\end{nolinenumbers}\fi
}
\makeatother

% >>>

% <<< table

\NewDocumentCommand \ra {} {\raggedright\arraybackslash}

\newenvironment{msctable}[2][\footnotesize]{
\vspace{-20pt}
\begin{center}
#1 % Set the right size (and font maybe)
\begin{tabular}{#2}
}{%
\end{tabular}
\end{center}
\vspace{-10pt}
}

\newenvironment{msclongtable}[2][\footnotesize]{
\vspace{-20pt}
\begin{center}
#1 % Set the right size (and font maybe)
\begin{longtable}{#2}
}{%
\end{longtable}
\end{center}
\vspace{-40pt}
}

\newenvironment{mscaorgoverview}[1][\footnotesize]{
\begin{msctable}{
    |>{\ra}p{0.165\linewidth}
    |>{\ra}p{0.075\linewidth}
    |>{\ra}p{0.15\linewidth}
    |>{\ra}p{0.155\linewidth}
    |>{\ra}p{0.155\linewidth}
    |>{\ra}p{0.155\linewidth}
    |>{\ra}p{0.15\linewidth}|}
\hline
\rowcolor{gray!40}
\textbf{Organisation Role} &
\textbf{PIC} &
\textbf{Legal Entity Short Name} &
\textbf{Academic Organisation (Y/N)} &
\textbf{Country} &
\textbf{Name of Supervisor} \\
\hline
}{
\hline
\end{msctable}
}

\newenvironment{mscaorgcapacity}{
% NOTE: This can contain a lot of text, so we make it long by default
\begin{msclongtable}[\small]{
    |>{\ra}p{0.3\linewidth}
    |>{\ra}p{0.66\linewidth}|}
\hline
}{
\hline
\end{msclongtable}
}

% >>>

% <<< cv

\newenvironment{cvitem}{
\noindent \begin{tabular}{@{}>{\ra}p{0.15\linewidth}>{\ra}p{0.8\linewidth}}
}{
\end{tabular}
\vspace{-3pt}
}

% NOTE: \cventry{dates}{name}{details}{location}
\NewDocumentCommand \cventry { m m m m } {\raggedleft \textbf{#1} & \textbf{#2}, \emph{#3}, #4. \\}
% NOTE: \cvdetail{name}{details}
\NewDocumentCommand \cvdetail { m m } {& \textbf{#1}: #2. \\}
% NOTE: \cvpub{date}{authors}{title}{journal etc}
\NewDocumentCommand \cvpub { m m m m } {\raggedleft \textbf{#1} & #2, \emph{#3}, #4. \\}

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
