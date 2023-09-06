% Michele Ceresoli, Politecnico di Milano ©2023
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{iac}[2023/09/05 International Astronautical Congress LaTeX Paper Class]

\LoadClass[twocolumn, A4paper, 10pt]{article}

% These package allows the use of a large range of mathematical formula, commands, and symbols 
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amstext}
\RequirePackage{amsfonts}

\RequirePackage{caption} % Provdes ways to customise the captions in figures and tables 
\RequirePackage{etoolbox} % Provides some programming tools for LaTeX (e.g., while expressions)
\RequirePackage{float} % Provide the option to impose the figures and tables positions
\RequirePackage[left=2.25cm, right=2.25cm, top=3.35cm, bottom=3.35cm]{geometry} % Allows editing of the page layout 

\RequirePackage{graphicx} % Required for inserting images
\RequirePackage{fancyhdr} % This package provides extensive facilities for constructing headers, footers and controlling their use
\RequirePackage{lastpage} % Allows writing in the footer the total number of pages 
\RequirePackage{longtable} % Implements multi-page table and other table settings
\RequirePackage{multirow} % Allows merging columns and rows in tables
\RequirePackage[normalem]{ulem} % Provides various types of underlining that can stretch between words and be broken across lines. The [normalem] option forbids ulem from replacing italics with underling
\RequirePackage[explicit,compact]{titlesec} % Provides an interface to customise the tytle styles

% General captions ettings
\captionsetup[figure]{name=Fig.,format=hang,indention=-20pt}
\captionsetup[table]{format=hang,indention=-24pt}

% This command avoids displaying a horizontal line below the header
\renewcommand{\headrulewidth}{0pt}

% Here we define the font size and the styles for the section, subsections, etc... headers 
\titlespacing{\section}{0pt}{*3}{*1.5}
\titlespacing{\subsection}{0pt}{*2.5}{*0.5}
\titlespacing{\subsubsection}{0pt}{*2}{*0.5}

\titleformat{\section}{\bfseries}{\arabic{section}.}{0.4em}{#1}
\titleformat{\subsection}{\itshape}{\arabic{section}.\arabic{subsection}}{0.2em}{#1}
\titleformat{\subsubsection}{\itshape}{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}}{0.2em}{#1}

% Define a set of commands are used to establish the IAC settings
\newcommand*{\IACpaperyear}[1]{\def \iac@paperyear{#1}}
\newcommand*{\IACpapernumber}[1]{\def \iac@papernumber{#1}}
\newcommand*{\IACconference}[1]{\def \iac@conference{#1}}
\newcommand*{\IAClocation}[1]{\def \iac@location{#1}}

% This internal command is used by \IACmainauthor to register the corresponding author data
\newcommand*{\IACmainauthoremail}[1]{\def \iac@cauthemail{#1}}

% These commands are used to write the different copyright format that can be adopted for the IAC paper
\newcommand{\IACcopyrightA}[1]{\def \iac@copyright{Copyright \copyright\,#1 by the International Astronautical Federation. All rights reserved.}}
\newcommand{\IACcopyrightB}[2]{\def \iac@copyright{Copyright \copyright\,#1 by #2. Published by the IAF, with permission and released to the IAF to publish in all forms.}}

% These command is used to define the paper authors 
\newcounter{authcount} % Authors counter
\newcounter{affcount}  % Affilitiations counter
\newcounter{cauthid}   % Counter to register the corresponding author id

\newcommand{\IACauthor}[2]{
    \stepcounter{authcount}
    \csdef{iac@author\theauthcount}{#1}
    \csdef{iac@authoraff\theauthcount}{#2}
}

\newcommand{\IACaffiliation}[1]{
    \stepcounter{affcount}
    \csdef{iac@affiliation\theaffcount}{#1}
}

% This command is used to define the corresponding author of the paper, and differently from the one above, it also registers the author's email
\newcommand{\IACmainauthor}[3]{
    \IACauthor{#1}{#2}
    \IACmainauthoremail{#3}
    \setcounter{cauthid}{\value{authcount}}
}

% Redefine what the \abstract command actually does 
\renewcommand{\abstract}[1]{\def\iac@abstract{#1}}

% This command is used to define the paper keywords 
\newcommand*{\IACkeywords}[1]{\def \iac@keywords{#1}}

% Define a new counter to keep track of the number of acronyms
\newcounter{acrocount}

% This command is used to register an acronym
\newcommand{\IACacronym}[2]{
    \stepcounter{acrocount}
    \csdef{iac@acronym\theacrocount}{#1}
    \csdef{iac@acronymdef\theacrocount}{#2}
}

% Command to write the title and the first page 
\renewcommand{\maketitle}{%

    % Set a font that is very similar to Times New Roman for the whoel document
    \fontfamily{ptm}\selectfont
    
    \twocolumn[%
        \begin{@twocolumnfalse}%
        \begin{center}%
            IAC--\iac@paperyear--\iac@papernumber\par%
            \vskip 1em%
            {\large \textsc{\@title} \par}%
            \vskip 1.5em%
            {\normalsize %
                \lineskip 0.5em%
                % Iteratively display the list of authors
                \newcounter{authnum}%
                \newcounter{authaff}%
                \whileboolexpr{%
                    test {\ifnumcomp{\value{authnum}}{<}{\theauthcount}}%
                }%
                {%
                    \stepcounter{authnum}%
                    \setcounter{authaff}{\csuse{iac@authoraff\theauthnum}}%
                    % Display the author name
                    \textbf{\csuse{iac@author\theauthnum}}%
                    % Display the author affiliation letter
                    $\,$\textsuperscript{\alph{authaff}}%
                    % Display an asterisk if the current author is the corresponding author (which might not necessarily be the first one of the list
                    \ifnum\theauthnum=\value{cauthid}{\textsuperscript{$\ast$}}\fi%
                    % Display the comma only if the current author is not the last
                    \ifnum\theauthnum<\theauthcount{\normalsize\textbf{,$\;$}}\fi%
                }%
            }%
        \end{center}%
        \vskip -0.7em
        % Iteratively display the author affiliations
        \newcounter{affnum}%
        \whileboolexpr{%
            test {\ifnumcomp{\value{affnum}}{<}{\theaffcount}}%
        }%
        {%
            \stepcounter{affnum}%
            \vskip 0.4em%
            \textsuperscript{\alph{affnum}} \textit{\csuse{iac@affiliation\theaffnum}}%
        }%
        \vskip 0.4em%
        \textsuperscript{$\ast$} Corresponding Author: \iac@cauthemail% 
        \vskip 1.0em
        \indent\iac@abstract\par%
        \vskip 1.0em%
        \textbf{Keywords:} \iac@keywords%
        \vskip 1.0em%
        % If the acronym counter is not empty create the abbreviation table
        \ifnum\theacrocount>0{
        \textbf{Abbreviations:}% 
        \newcounter{acronum}%
        \begin{longtable}[l]{l l}
        \whileboolexpr{%
            test {\ifnumcomp{\value{acronum}}{<}{\theacrocount}}%
        }%
        {%
        \stepcounter{acronum}
            \csuse{iac@acronym\theacronum} & \csuse{iac@acronymdef\theacronum}\\
        }%
        \end{longtable}%
        \phantom{ciao}
        }\fi%
        \end{@twocolumnfalse}%
    ]%

}

% These settings style the header and the footer according to the provided IAC settings
\pagestyle{fancy}
\fancyhead{}
\fancyfoot{}
\fancyhead[C]{\footnotesize{\iac@conference\textsuperscript{th} International Astronautical Congress (IAC), {\iac@location}.\\ \iac@copyright}}
\fancyfoot[L]{IAC--\iac@paperyear--\iac@papernumber}
\fancyfoot[R]{Page \thepage\ of \pageref{LastPage}}


\setlength\parindent{12pt}
