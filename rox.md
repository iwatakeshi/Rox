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
program                   → statement* EOF ;

statement                 → expression-statement
                          | print-statement ;
expresion-statement       → expression (";") ;
print-statement           → "print" expression ";" ;
expression                → equality ;
equality                  → comparison ( ( "!=" | "==" ) comparison )* ;
comparison                → addition ( ( ">" | ">=" | "<" | "<=" ) addition )* ;
addition                  → multiplication ( ( "-" | "+" ) multiplication )* ;
multiplication            → unary ( ( "/" | "*" ) unary )* ;
unary                     → ( "!" | "-" ) unary ;
                          | primary ;
primary                   → NUMBER | STRING | "false" | "true" | "nil"
                          | "(" expression ")" ;
```

## Types

| Rox type  |	Swift representation   |
|-----------|------------------------|
| `null`	  |        `nil`           |
| `boolean`	|        `Bool`          |
| `number`	|        `Double`        |
| `string`	|        `String`        |