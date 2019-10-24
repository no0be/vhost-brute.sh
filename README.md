# vhost-brute.sh

`vhost-brute.sh` will take an URI and a wordlist as input parameters and use `curl` to perform as many HTTP requests as there are lines in the provided wordlist. Every request will have a different value for its `Host` header and the output will show the SHA256 hash of each of the responses body.

```
$ ./vhost-brute.sh https://google.com namelist.txt
localhost:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
127.0.0.1:2178eedd5723a6ac22e94ec59bdcd99229c87f3623753f5e199678242f0e90de
192.168.1.1:2178eedd5723a6ac22e94ec59bdcd99229c87f3623753f5e199678242f0e90de
example.org:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
```

## Usage
```
Usage:
      ./vhost-brute.sh [-h] [-d DOMAIN] URI WORDLIST
Arguments:
      URI         targeted URI (i.e. http(s)://server[:port])
      WORDLIST    path to wordlist
Options:
      -h          Display this help
      -d [DOMAIN] Append a fixed domain name to all items of the specified wordlist
Example:
      ./vhost-brute.sh -d example.org http://192.168.1.1 namelist.txt
```

In order to pinpoint interesting vhosts, save the output of `vhost-brute.sh` to a log file using `tee` and then use `grep -v` to remove the most common response.

**Example**:
```bash
$ ./vhost-brute.sh -d google.com https://google.com namelist.txt | tee google.log
0.google.com:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
01.google.com:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
02.google.com:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
03.google.com:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
1.google.com:21dcd29c3374db313b66792757fb03e514cd447c6a0ce5f691eee7fa47419d97
10.google.com:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
11.google.com:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
12.google.com:23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660
...

$ grep -v 23926e9185d8d43c02807a838ffb373cc1977726094a4e46807c66ada9dd7660 google.log
1.google.com:21dcd29c3374db313b66792757fb03e514cd447c6a0ce5f691eee7fa47419d97
```
