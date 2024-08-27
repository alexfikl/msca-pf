MSCA-PF: LaTeX Template
-----------------------

LaTeX class and template for Marie Skłodowska-Curie Actions Postdoctoral Fellow
grant applications.

* Details and original template is provided
  `here <https://rea.ec.europa.eu/funding-and-grants/horizon-europe-marie-sklodowska-curie-actions/horizon-europe-msca-how-apply_en>`__
  (calls are updated each year).

* For the official editable version of the template, you must start the submission
  process. The template will then be available on the left-hand side in a section
  named "Download Part B templates".

* For a similar template for the Doctoral Network see
  `msca-dn <https://github.com/pgarner/msca-dn>`__.

**Caution**: Only the 2022 template was submitted and deemed eligible by the
Horizon program. Newer versions are simply updated based on the official template.
Reporting any discrepancies is highly appreciated!

Fonts
-----

The official MSCA guidelines require the Times New Roman font on Windows or
macOS and the Nimbus Roman font on Linux. When using PDFLaTeX this package
uses the ``mathptmx`` font. When using XeLaTeX or LuaLaTeX, we try to load
the Times New Roman font and, if it is not available, the Nimbus Roman font.

If these do not work for you, you can load fonts yourself using e.g.

.. code:: tex

    % on PDFLaTeX
    \usepackage{newtxtext}
    \usepackage{newtxmath}

    % on XeLaTeX / LuaLaTeX
    \setmainfont{Times New Roman}

Building
--------

The resulting PDF files are included for easy viewing, but it is recommended to
build the two parts with e.g. `latexmk` as follows

.. code:: bash

    latexmk -pdflua msca-pf-part-b1-template.tex
    latexmk -pdflua msca-pf-part-b2-template.tex

Functionality
-------------

This packages provides the ``msca-pf`` class that is based on the
KOMA-script ``scrartcl`` class and accepts any options meant for it. It can
be used as

.. code:: latex

    \documentclass[11pt,layoutgrid,draftproposal]{msca-pf}

    % ... preamble ...

    \begin{document}

    % ... content ...

    \end{document}

The class has two options meant for drafting:

* ``layoutgrid``: overlays a grid on top of each page to check margins and
  other alignment issues.
* ``draftproposal``: adds helpful drafting options, such as line numbers and
  a time stamp.

It also provides a few useful commands that can be used in the proposal. The
following commands are mandatory:

* ``mscaidentifier``: the call identifier, e.g. ``HORIZON-MSCA-2022-PF-01``. This
  should be set to the appropriate version by default.
* ``mscaproject``: the acronym for the project.

Additionally, there are also some commands to help constructing the CV and other
little tables in the submission:

* ``mscaorgoverview``: an environment (wrapper around ``tabular``) that defines
  the table template from Section 5.1 for participating organisations. This is a
  fixed 6 column table.
* ``mscaorgcapacity``: an environment (wrapper around ``longtable``) that defines
  the table template from Section 5.2 for participating organisations. This is a
  fixed 2 column table.
* ``cvitem``: an environment to define a nicely aligned CV item.
* ``\cventry{dates}{name}{details}{location}``: a generic entry in the CV. Use
  ``\cventryitem`` to get one already wrapped in the ``cvitem`` environment.
* ``\cvdetail{name}{description}``: a additional description for an entry.
* ``\cvpub{date}{authors}{title}{journal}``: a publication. Use
  ``\cvpubitem`` to get one already wrapped in the ``cvitem`` environment.

The CV commands can be used in the following fashion:

.. code:: tex

    % examples for a general entry
    \begin{cvitem}
    \cventry{DD/MM/YYYY DD/MM/YYYY}{Ph.D. in Aerospace Engineering}{University Name}{Location}
    \cvdetail{Title}{Title of my Ph.D}
    \cvdetail{Advisor}{John Doe}
    \end{cvitem}

    \begin{cvitem}
    \cventry{DD/MM/YYYY DD/MM/YYYY}{Job Title}{Company / University}{Location}
    \cvdetail{Description}{Job description in short}
    \end{cvitem}

    % example for a publication
    \begin{cvitem}
    \cvpub{DD/MM/YYYY}{John Doe, Jane Doe}{Title of the Paper}
                      {Journal Name, Vol. XX, pp. XX--XX}
    \cvdetail{Description}{Main findings of the paper}
    \cvdetail{URL}{DOI or arXiV URL}
    \end{cvitem}

    # example for a bare publication (same as above without the details)
    \cvpubitem{DD/MM/YYYY}{John Doe, Jane Doe}{Title of the Paper}
                          {Journal Name, Vo. XX, pp. XX-XX}

A Gantt chart must also be provided in the proposal. There are some LaTeX packages,
e.g. `pgfgantt <https://ctan.org/pkg/pgfgantt?lang=en>`__, that can be used to
create such charts. However, you can also just use a third party application,
export the chart as a PNG or PDF, and include it like that.
