# Rox Specification


## Precedence and Associativity

|  Name           | Operators        |  Associates  |
|-----------------|------------------|--------------|
| Unary           |`!` `-`           |    Right     |
| Multiplication  |`/` `*`           |    Left      |
| Addition        |`-` `+`           |    Left      |
| Comparison      |`>` `>=` `<` `<=` |    Left      |
| Equality        |`==` `!=`         |    Left      |

## Grammar

```
program                   → declaration* EOF ;

declaration               → var-declaration
                          | statement

var-declaration           → "var" IDENTIFIER ("=" expression)? (";")?
statement                 → expression-statement
                          | print-statement ;
expresion-statement       → expression (";")? ;
print-statement           → "print" expression (";")? ;
expression                → assignment
assignment                → identifier "=" assignment
                          | equality ;
equality                  → comparison ( ( "!=" | "==" ) comparison )* ;
comparison                → addition ( ( ">" | ">=" | "<" | "<=" ) addition )* ;
addition                  → multiplication ( ( "-" | "+" ) multiplication )* ;
multiplication            → unary ( ( "/" | "*" ) unary )* ;
unary                     → ( "!" | "-" ) unary ;
                          | primary ;
primary                   → "true" | "false" | "null"
                          | NUMBER | STRING
                          | "(" expression ")"
                          | IDENTIFIER ;
```

## Types

| Rox type  |	Swift representation   |
|-----------|------------------------|
| `null`	  |        `nil`           |
| `boolean`	|        `Bool`          |
| `number`	|        `Double`        |
| `string`	|        `String`        |