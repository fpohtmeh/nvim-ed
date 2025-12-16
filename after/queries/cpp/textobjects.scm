; extends

; Function declarations in headers
(declaration) @function.outer

; Method declarations within class bodies
(field_declaration
  declarator: (function_declarator)) @function.outer
