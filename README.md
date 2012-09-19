# Watnow

<b>Watnow</b> finds and lists your project TODOs and FIXMEs.<br>
It basically does what the Rails’ `rake notes` does, but in a more generic way.

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
Opens an annotation in your $EDITOR focused on the annotation line.
```sh
$ watnow open 13
```

### remove
Removes the annotation line from its file.<br>
(Make sure there is nothing else on that line)
```sh
$ watnow remove 13
```

## Features
### Mentions
```rb
# TODO @rafBM: Update user form
# TODO Update user controller @rafBM
```
```sh
[ 2 ] TODO: Update user form [ @rafBM ]
[ 1 ] TODO: Update user controller [ @rafBM ]
```

### Priority
Exclamation mark (!) preceded by a whitespace. (`/\s(!+)\s?/`)

```rb
# TODO !!!: This is level 3 urgent
# TODO @rafBM: Just do it !
# TODO !!!!!!!!!!!!! @EtienneLem: This is a nicolas-cage-level urgent task
```
```sh
[ 2 ]  TODO: Just do it [ @rafBM - ! ]
[ 1 ]  TODO: This is level 3 urgent [ !!! ]
[ 3 ]  TODO: This is a nicolas-cage-level urgent task [ @EtienneLem - !!!!!!!!!!!!! ]
```

### Super color-friendly
(Seriously, I’m open to color suggestions…)
![color-friendly](https://s3.amazonaws.com/watnow/colors.png)

## Watnow config
Override defaults in `~/.watnowconfig`. Supported options are:
```
username  (String)    | A username so that you can be mentioned in TODOs  | Default: ''
color     (Boolean)   | Enable/disable colored output                     | Default: true
patterns  (Array)     | An array of string/regex that you want to monitor | Default: []
```

Use YAML syntax:
```
username: EtienneLem
color: false
patterns: [potato, ba(na)+]
```

## Contribution
My Ruby skills are far from exemplary, please teach me.
