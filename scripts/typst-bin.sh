#!/usr/bin/env bash

resolve_typst_bin() {
  local candidate="${TYPST_BIN:-typst}"
  if command -v "$candidate" >/dev/null 2>&1; then
    printf '%s\n' "$candidate"
    return 0
  fi

  if command -v powershell.exe >/dev/null 2>&1; then
    local win_path
    win_path="$(powershell.exe -NoProfile -Command '(Get-Command typst).Source' 2>/dev/null | tr -d '\r')"
    if [[ -n "$win_path" ]]; then
      if command -v cygpath >/dev/null 2>&1; then
        cygpath -u "$win_path"
      elif [[ "$win_path" =~ ^([A-Za-z]):\\(.*)$ ]]; then
        local drive="${BASH_REMATCH[1],,}"
        local rest="${BASH_REMATCH[2]//\\//}"
        if [[ -d "/mnt/$drive" ]]; then
          printf '/mnt/%s/%s\n' "$drive" "$rest"
        else
          printf '/%s/%s\n' "$drive" "$rest"
        fi
      else
        printf '%s\n' "$win_path"
      fi
      return 0
    fi
  fi

  echo "typst executable not found. Set TYPST_BIN or add typst to PATH." >&2
  return 1
}

typst_path() {
  local path="$1"
  local bin="${2:-}"
  if [[ "$bin" == *.exe && "$path" == /mnt/* ]] && command -v wslpath >/dev/null 2>&1; then
    wslpath -w "$path"
  else
    printf '%s\n' "$path"
  fi
}
