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
expression     → equality ;
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
comparison     → addition ( ( ">" | ">=" | "<" | "<=" ) addition )* ;
addition       → multiplication ( ( "-" | "+" ) multiplication )* ;
multiplication → unary ( ( "/" | "*" ) unary )* ;
unary          → ( "!" | "-" ) unary ;
               | primary ;
primary        → NUMBER | STRING | "false" | "true" | "nil"
               | "(" expression ")" ;
```