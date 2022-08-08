% <<< preamble

\def\fileversion{v1.0}
\def\filedate{2022/08/08}
\def\clsname{msca-pf-2022}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{\clsname}[\filedate\ \fileversion\ MSCA PF Proposal]

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

\if@draftproposal
    \newcount\timehh\newcount\timemm
    \timehh=\time \divide\timehh by 60
    \timemm=\time \count255=\timehh \multiply\count255 by -60
        \advance\timemm by \count255
    \def\draftheader{\small \slshape Draft of \today}
\else
    \def\draftheader{\empty}
\fi

% >>>

% <<< required packages

% NOTE: load packages after the class was loaded since they may depend on it

% required font is Times Roman (or Nimbus Roman on Linux)
\RequirePackage{mathptmx}

% build fancy table required for organization description
\RequirePackage{array}
\RequirePackage[table]{xcolor}
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
}

% >>>

% <<< main matter

% add line numbers if in draft mode
\if@draftproposal
    \RequirePackage[mathlines]{lineno}
    \RequirePackage{xcolor}
    \renewcommand{\linenumberfont}{
        \normalfont\footnotesize\textcolor{black!50}
    }

    \let\thesis@mainmatter=\mainmatter
    \def\mainmatter{\linenumbers\thesis@mainmatter}

    % The \linenumbers command does not play nice with amsmath, so we
    % have added some patches to fix it. See
    % http://phaseportrait.blogspot.com/2007/08/lineno-and-amsmath-compatibility.html
    \newcommand*{\patchAmsMathEnvironmentForLineno}[1]{%
        \expandafter\let\csname old#1\expandafter\endcsname\csname #1\endcsname
        \expandafter\let\csname oldend#1\expandafter\endcsname\csname end#1\endcsname
        \renewenvironment{#1}%
            {\linenomath\csname old#1\endcsname}%
            {\csname oldend#1\endcsname\endlinenomath}}%

    \newcommand*{\patchBothAmsMathEnvironmentsForLineno}[1]{%
        \patchAmsMathEnvironmentForLineno{#1}%
        \patchAmsMathEnvironmentForLineno{#1*}}%

    \AtBeginDocument{%
        \patchBothAmsMathEnvironmentsForLineno{equation}%
        \patchBothAmsMathEnvironmentsForLineno{align}%
        \patchBothAmsMathEnvironmentsForLineno{flalign}%
        \patchBothAmsMathEnvironmentsForLineno{alignat}%
        \patchBothAmsMathEnvironmentsForLineno{gather}%
        \patchBothAmsMathEnvironmentsForLineno{multline}%
    }
\fi

% >>>

% <<< page header/footer styles

\pagestyle{plain}
\clearpairofpagestyles

\def\callheader{\small \textsc{HORIZON-MSCA-2022-PF-01} -- MSCA Postdoctoral Fellowships 2022}
\def\pagefooter{Part B -- Page \thepage\, of\, \pageref{LastPage}}

\cfoot[\pagefooter]{\pagefooter}
\ohead[\draftheader]{\draftheader}
\ihead[\callheader]{\callheader}

% >>>

% <<< title

\def\@maketitle{
\begin{center}
    \normalfont \normalsize
    \vspace{0.2cm}
    {\huge \bfseries \@title \par}
    \vspace{0.3cm}
\end{center}
}
\makeatother

% >>>

% <<< table

\newenvironment{msctable}[2][\footnotesize]{
\begin{center}
#1 % Set the right size (and font maybe)
\newcommand{\ra}{\raggedright\arraybackslash}
\begin{tabular}{#2}
}{%
\end{tabular}
\end{center}
}

% >>>

\recalctypearea

\endinput
