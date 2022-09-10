adb-logcat-app
==============

> Stream logs with `adb` filtered by app id.

## Install

Available as a [bpkg](https://github.com/bpkg/bpkg):

```sh
bpkg install -g socketsupply/adb-logcat-app
```

## Usage

```
usage: adb-logcat-app [-hV] [adb logcat options] <appid>

adb logcat options:
  See 'adb logcat -h'

options:
  -h,--help      Print this help dialogue and exit
  -V,--version   Print the current version and exit
```

## Example

```sh
adb-logcat-app "com.example.app" # will poll and print logs for this application, forever
```

## License

MIT
