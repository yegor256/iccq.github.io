% SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
% SPDX-License-Identifier: MIT

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cfp}[17/4/2021 0.1.0 Template for CFPs]

\LoadClass[12pt,oneside]{article}

\RequirePackage[utf8]{inputenc}
\RequirePackage{microtype}
\RequirePackage{wrapfig}
\RequirePackage{fontspec}
  \setmainfont{Consolas}[
    Path=../,
    Extension=.ttf,
    UprightFont=consolas
  ]
\RequirePackage{xcolor}
  \input{colors.tex}
\RequirePackage{hyperref}
  \hypersetup{colorlinks=true,allcolors=red}
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
      \tikz \node[fill=red,minimum width=0.5\TPHorizModule,minimum height=16\TPVertModule] {};
    \end{textblock}%
  }
\RequirePackage[absolute]{textpos}\TPGrid{16}{16}
\RequirePackage{tikz}


\AtBeginDocument{%
  \raggedbottom
  \raggedright
  \setlength{\topskip}{6pt}
  \setlength{\parindent}{0pt} % indent first line
  \setlength{\parskip}{6pt} % before par
}

\newcommand\PrintCity[2]{
  \begin{textblock}{16}[1,1](16,16)
    \raggedleft
    \includegraphics[width=#1\TPHorizModule]{#2}
  \end{textblock}
}

\newcommand\PrintLogo{%
  \begin{textblock}{2.5}[1,0](14,1.5)%
    \includegraphics[width=\textwidth]{../../images/logo/logo.pdf}
  \end{textblock}
}

\newcommand\person[2]{%
  \begin{minipage}[t]{0.22\textwidth}\raggedright%
    \includegraphics[height=0.6in]{../../images/#1} \\
    {\small #2}%
  \end{minipage}
}

\newcommand\PrintTitle[1]{%
  {\color{red}\bfseries
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
