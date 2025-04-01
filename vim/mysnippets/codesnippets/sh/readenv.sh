read_env() {
  local filename="${1:-.env}"

  if [ ! -f "$filename" ]; then
    echo "missing ${filename} file"
    exit 1
  fi

  echo "reading .env file..."
  while read -r LINE; do
    if [[ $LINE != '#'* ]] && [[ $LINE == *'='* ]]; then
      export "$LINE"
    fi
  done < "$filename"
}
