# Cheatsheet for nvim-ed

## Basic Motions
- H - move to the first visible symbol in line
- L - move to the last visible symbol in line

## mini.ai
### triggers
- a - around
- i - inside
### motions
- w - word
- W - WORD
- e - part of word
- p - paragraph
- g - buffer
- ? - input
- b - alias for `), ], or }`
- q - alias for `', ", or` \`
- f - function
- a - argument
- t - tag
- c - comment

## mini.surround
### triggers
- ys - yank
- ds - delete
- cs - change
- yh - highlight

## mini.bracketed
### mappings
#### general
- ,b/;b - previous/next buffer
- ,F/;F - previous/next file
- ,f/;f - previous/next function
- ,I/;I - previous/next indent
- ,t/;t - previous/next todo item
#### quickfix
- ,q/;q - previous/next quickfix item
- ,Q/;Q - first/last quickfix item
- ,<c-q>/;<c-q> - previous/next quickfix list
#### git
- ,g/;g - previous/next unstage git file
- ,h/;h - previous/next hunk
- ,H/;H - first/last hunk
#### diagnostics
- ,d/;d - previous/next diagnostics
- ,e/;e - previous/next error
- ,w/;w - previous/next warning
