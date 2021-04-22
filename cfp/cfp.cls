\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cfp}[17/4/2021 0.1.0 Template for CFPs]
\LoadClass[12pt,oneside]{article}
\RequirePackage[utf8]{inputenc}
\RequirePackage{microtype}
\RequirePackage{wrapfig}
\RequirePackage{xcolor}
  \definecolor{xred}{HTML}{b02428}
\RequirePackage{hyperref}
  \hypersetup{colorlinks=true,allcolors=xred}
\RequirePackage[left=1.5in, right=1in, top=1.2in, bottom=1.2in]{geometry}
\RequirePackage{changepage}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
  \pagestyle{fancy}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
  \fancyhf{}
  \fancyfoot[C]{
    \begin{textblock}{0.5}[0,0](0,0)
      \tikz \node[fill=xred,minimum width=0.5\TPHorizModule,minimum height=16\TPVertModule] {};
    \end{textblock}%
    \ifnum\value{page}=1
      \begin{textblock}{16}[1,1](16,16)
        \raggedleft
        \includegraphics[width=16\TPHorizModule]{../kazan}
      \end{textblock}
    \else\fi
  }
\RequirePackage[absolute]{textpos}\TPGrid{16}{16}
\RequirePackage{tikz}

\AtBeginDocument{%
  \fontfamily{cmtt}\selectfont
  \raggedbottom
  \raggedright
  \setlength{\topskip}{6pt}
  \setlength{\parindent}{0pt} % indent first line
  \setlength{\parskip}{6pt} % before par
}

\newcommand\PrintLogo{%
  \begin{wraptable}{r}{1.2in}%
    \raggedleft%
    \includegraphics[height=1.2in]{../../logo}
  \end{wraptable}
}

\newcommand\person[2]{%
  \begin{minipage}[t]{0.22\textwidth}\raggedright%
    \includegraphics[height=0.6in]{../../images/#1} \\
    {\small #2}%
  \end{minipage}
}

\newcommand\PrintTitle[1]{%
  {\color{xred}\bfseries
    {\large The #1} \newline
    {\Large International Conference on \\[3pt] Code Quality (ICCQ)}
  }
}

\newcommand\PrintAddress[4]{
  #1 \newline
  #2 \newline
  \href{https://www.iccq.ru}{www.iccq.ru} /
  \href{#3}{#4}
}

\endinput