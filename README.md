# ricing_bootstrap

# How many lines written
``` bash
find . -type f \
  ! -path "./.git/*" \
  ! -name "LICENSE" \
  ! -name "README.md" \
  -exec wc -l {} + | sort -n
```