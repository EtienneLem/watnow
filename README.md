# Watnow

`watnow` finds and lists your project TODOs and FIXMEs in your terminal<br>
Basically it does what the Rails’ `rake notes` does, but for all kind of projects

## Installation
```sh
$ gem install watnow
```

## Usage

```sh
$ watnow --help

Usage: watnow [options]

-h, --help               show this message
-v, --version            display version
-d, --directory DIR      directory DIR to scan (defaults: ./)

watnow commands:
open <ID>    open annotation ID in your editor
remove <ID>  remove annotation ID
```

## Commands
### open
Opens an annotation in your $EDITOR focused on the annotation line
```sh
$ watnow open 13
```

### remove
Removes the annotation line form its file
```sh
$ watnow remove 13
```

## Watnow config
You can override default configs in a `~/.watnowconfig` file. Supported options are:
- color (Boolean)  | Enable/disable colored output
- Patterns (Array) | An array of string that you want to monitor

Use a YML syntax:
```
color: false
patterns: [banana, potato]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
