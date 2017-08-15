# Rox
A fun and simple languange for smarties

[![Build Status](https://travis-ci.org/iwatakeshi/Rox.svg?branch=master)](https://travis-ci.org/iwatakeshi/Rox)

## Rox Specification

### Precedence and Associativity

|  Name           | Operators        |  Associates  |
|-----------------|------------------|--------------|
| Unary           |`!` `-`           |    Right     |
| Multiplication  |`/` `*`           |    Left      |
| Addition        |`-` `+`           |    Left      |
| Comparison      |`>` `>=` `<` `<=` |    Left      |
| Equality        |`==` `!=`         |    Left      |

### Grammar

```
program                   → declaration* EOF ;

declaration               → var-declaration
                          | statement ;

var-declaration           → "var" IDENTIFIER ("=" expression)? (";")?
statement                 → expression-statement
                          | for-statement
                          | if-statement
                          | print-statement
                          | while-statement
                          | block-statement
expresion-statement       → expression (";")? ;
for-statement             → "for" IDENTIFIER "in" expression body
if-statement              → "if" ("(")? expression (")")? statement ("else" statement)
print-statement           → "print" expression (";")? ;
block-statement           → "{" declaration* "}"
expression                → assignment ;
assignment                → IDENTIFIER "=" assignment
                          | logical-or ;
logical-or                → logical-and ("or" logical-or)* ;
logical-and               → equality ("and" equality)* ;
equality                  → comparison ( ( "!=" | "==" ) comparison )* ;
comparison                → addition ( ( ">" | ">=" | "<" | "<=" ) addition )* ;
addition                  → multiplication ( ( "-" | "+" ) multiplication )* ;
multiplication            → unary ( ( "/" | "*" ) unary )* ;
unary                     → ( "!" | "-" ) unary
                          | primary ;
primary                   → "true" | "false" | "null"
                          | NUMBER | STRING
                          | "(" expression ")"
                          | IDENTIFIER ;
```

### Types

| Rox type  |	Swift representation   |
|-----------|------------------------|
| `null`	  |        `nil`           |
| `boolean`	|        `Bool`          |
| `number`	|        `Double`        |
| `string`	|        `String`        |