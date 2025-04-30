# ricing_bootstrap

# How many lines written
``` bash
for file in $(ls | sort -n); do
  if [[ -x "$file" && "$file" == *.sh && "$file" != x* ]]; then
    echo "Running $file"
    ./"$file"
  fi
done
```