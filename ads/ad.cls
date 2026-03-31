% SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
% SPDX-License-Identifier: MIT
%
% ad.cls - LaTeX class for ICCQ advertisement materials
%
% Usage:
%   \documentclass{ad}
%   \adsetup{paperwidth=300pt, paperheight=250pt, left=10pt, right=10pt, top=10pt, bottom=10pt}
%   \adgrid{16}{16}
%   \begin{document}
%   ...
%   \end{document}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ad}[2026/01/01 ICCQ Ad Class]

\LoadClass{article}

\RequirePackage{geometry}
\RequirePackage[absolute]{textpos}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{bold-extra}
\RequirePackage{anyfontsize}
\RequirePackage{xcolor}

\input{colors.tex}

\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\fancyhf{}

\newcommand{\adsetup}[1]{\geometry{#1}}
\newcommand{\adgrid}[2]{\TPGrid{#1}{#2}}
\newcommand{\invert}[1]{\colorbox{red}{\textcolor{white}{#1}}}

\AtBeginDocument{%
  \fontfamily{cmtt}\selectfont
  \raggedbottom
  \raggedright
  \setlength{\topskip}{6pt}
  \setlength{\parindent}{0pt}
  \setlength{\parskip}{6pt}
  \color{black}%
}

\endinput
