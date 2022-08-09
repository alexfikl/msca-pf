MSCA-PF: LaTeX Template
-----------------------

LaTeX class and template for Marie Skłodowska-Curie Actions Postdoctoral Fellow
grant applications. This is currently geared towards the templates from the
2022 call, but contributions for updates to future requirements are more than
welcome!

* Details and original template is provided `here <https://rea.ec.europa.eu/funding-and-grants/horizon-europe-marie-sklodowska-curie-actions/horizon-europe-msca-how-apply_en#postdoctoral-fellowships--call-2022>`__.

* For a `docx` version of the template, see `this document <https://rea.ec.europa.eu/document/download/45a8649f-aa5f-4264-8051-ea5b28bcbd65_en?filename=Tpl_Application%20form%20%28Part%20B%29%20%28HE%20MSCA%20PF%29_0.docx>`__.

* For a similar template for the Doctoral Network see `msca-dn <https://github.com/pgarner/msca-dn>`__.

Building
--------

The resulting PDF files are included for easy viewing, but it is recommended to
build the two parts with `latexrun` as follows

.. code:: bash

    latexrun msca-pf-part-b1-template.tex
    latexrun msca-pf-part-b2-template.tex

Functionality
-------------

This packages provides the ``msca-pf-2022`` class that is based on the
KOMA-script ``scrartcl`` class and accepts any options meant for it. It can
be used as

.. code:: latex

    \documentclass[11pt,layoutgrid,draftproposal]{msca-pf-2022}

    % ... preamble ...

    \begin{document}

    % ... content ...

    \end{document}

The class has two options meant for drafting:

* ``layoutgrid``: overlays a grid on top of each page to check margins and
  other alignment issues.
* ``draftproposal``: adds helpful drafting options, such as line numbers and
  a time stamp.

It also provides a few useful commands that can be used in the proposal:

* ``msctable``: a wrapper around ``tabular`` that can be used in the exact
  same way, but imposes a consistent font size and formatting for tables.
* ``cvitem``: used as ``\cvline{dates}{main}{details}{location}`` to add a
  simple line to the required CV.
* ``cvdetail``: used as ``\cvdetail{name}{description}`` to add properly
  aligned comments to entries.
* ``cvpub``: used as ``\cvpub{date}{authors}{title}{journal}`` to add a
  publication.
