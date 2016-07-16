# Plain-text ccKres

Plain-text version of [ccKres] 1.0, the corpus of written Slovenian language.
Includes a few examples of tools to extract useful information from [TEI] fies.

The plain-text files can be found in the
[`plain-text-corpus`][plain] directory, sorted as follows:

    SSJ
    ├── I             - internet
    └── T             - tisk (print)
        ├── D         - drugo (other)
        ├── K         - knjižno (literary)
        │   ├── L     - leposlovje (fiction)
        │   └── S     - strokovno (non-fiction)
        └── P         - periodično (periodicals)
            ├── C     - časopis (newspapers)
            └── R     - revija (magazines)

Although the text files were produced using `teitomarkdown` (part of
[TEIC/Stylesheets][teic]), the result is barely formatted into paragraphs. The
text will therefore need substantial preprocessing for most uses.

Additionally we have extracted a list of all words found in the corpus,
together with their morphosyntactic annotations (see
[morphosyntax_dict.txt](morphosyntax_dict.txt)).

## Examples

  * [Counting number of verbs in input text](examples/count_verbs.rb)
  * [Finding words that can belong to multiple
    categories](examples/multiple_categories.rb)

## Generating plain-text files

This repository already contains [exctracted plain-text files][plain]. If, for
whatever reason, you want to regenerate them, this is how they were originally
generated:

    $ rake kres:download[cckres]
    $ rake kres:extract[cckres]
    $ rake kres:sort[cckres,plain-text-corpus]

To generate the morphosyntactic dictionary:

    $ rake kres:msd[~/Downloads/cckresV1_0/xml] \
      | sort \
      | uniq \
      > morphosyntax_dict.txt

The above tasks require the following programs to be available in your `PATH`:

  * `curl`
  * `unzip`
  * `find`
  * `ruby`

Ruby dependencies must be installed as well (`gem install bundler` if needed):

    $ gem install bundler
    $ bundle install

## License

The code is licensed under the [MIT] license. The [ccKres] corpus is licensed
under [CC BY-NC-SA 4.0][cc].

[cckres]: http://eng.slovenscina.eu/korpusi/proste-zbirke
[tei]: http://www.tei-c.org/Guidelines/P5/
[teic]: https://github.com/TEIC/Stylesheets/tree/dev/bin
[plain]: plain-text-corpus
[mit]: https://opensource.org/licenses/MIT
[cc]: https://creativecommons.org/licenses/by-nc-sa/4.0/
