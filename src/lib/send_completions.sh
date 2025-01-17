## [@bashly-upgrade completions send_completions]
send_completions() {
  echo $'# cliferay completion                                      -*- shell-script -*-'
  echo $''
  echo $'# This bash completions script was generated by'
  echo $'# completely (https://github.com/dannyben/completely)'
  echo $'# Modifying it manually is not recommended'
  echo $''
  echo $'_cliferay_completions_filter() {'
  echo $'  local words="$1"'
  echo $'  local cur=${COMP_WORDS[COMP_CWORD]}'
  echo $'  local result=()'
  echo $''
  echo $'  if [[ "${cur:0:1}" == "-" ]]; then'
  echo $'    echo "$words"'
  echo $''
  echo $'  else'
  echo $'    for word in $words; do'
  echo $'      [[ "${word:0:1}" != "-" ]] && result+=("$word")'
  echo $'    done'
  echo $''
  echo $'    echo "${result[*]}"'
  echo $''
  echo $'  fi'
  echo $'}'
  echo $''
  echo $'_cliferay_completions() {'
  echo $'  local cur=${COMP_WORDS[COMP_CWORD]}'
  echo $'  local compwords=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")'
  echo $'  local compline="${compwords[*]}"'
  echo $''
  echo $'  case "$compline" in'
  echo $'    \'stats headless-summary\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats users emails\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'curl batch-import\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'curl new-instance\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats users jira\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'changed-modules\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--branch --help -b -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'curl new-object\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'elastic-search\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats assigned\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'format-source\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats ranking\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats tickets\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats commits\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'curl new-api\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats review\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'super-deploy\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--branch --help -b -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats years\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats users\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h emails jira")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'set-ticket\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--branch --help -b -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'build-rest\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'backport\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--branch --help -b -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'baseline\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'tickets\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'curl ai\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--generate --help -g -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'morning\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--force --help --no-nuke -f -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'deploy\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'update\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'build\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'stats\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h assigned commits headless-summary ranking review tickets users years")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'brian\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'poshi\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'owner\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'sync\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'nuke\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'kill\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'gogo\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h diag jaxrs:check scr:list unsatisfied")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'curl\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h ai batch-import new-api new-instance new-object")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'init\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--email --help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'jira\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'run\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--clustered --help -c -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'ant\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'sd\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--branch --help -b -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'cm\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--branch --help -b -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'ij\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'gw\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'sf\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'b\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--branch --help -b -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'d\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    *)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cliferay_completions_filter "--help --version -h -v ant b backport baseline brian build build-rest changed-modules cm curl d deploy elastic-search format-source gogo gw ij init jira kill morning nuke owner poshi run sd set-ticket sf stats super-deploy sync tickets update")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'  esac'
  echo $'} &&'
  echo $'  complete -F _cliferay_completions cliferay'
  echo $''
  echo $'# ex: filetype=sh'
}