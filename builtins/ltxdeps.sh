#!/usr/bin/env bash
jq -r '.tasks|.[]|.deps|.[]|select(.[0] == "file")|.[1]|.[]|select(test("(^[^\\/].*\\.tex$)|(^'"$PWD"'/[^\\/]*.tex$)"))' latex.out/.latexrun.db
