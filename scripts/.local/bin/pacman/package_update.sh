#!/bin/bash

# Este script verifica quantos pacotes precisam de atualização.
# Como o script deveria rodar em uma barra de estado, não pode
# demorar muito tempo para concluir. Mas o comando `checkupdates`
# é um comando lento e, por isso, o script fica "preso", atrasando
# atualizações na barra de estado.
# Então, a solução foi gerar a lista de pacotes em um arquivo temporário
# que será atualizado apenas se não existir, ou se tiver mais de
# 1 hora de vida.
# A saída final é a quantidade de linhas deste arquivo temporário que
# contém a lista de pacotes que precisam ser atualizados.

# Arquivo que vai receber a lista de pacotes a atualizar.
pul="${TMPDIR:-/tmp}/pkg_update_list" # pul = Package Update List
# Número inicial de pacotes para atualizar.
package_value=0
# Ícone da informação
package_icon=" "

get_package_count(){
    # Se o arquivo com a lista de pacotes para atualizar não existir ou
    # possuir mais de 1 hora de criação, devemos criá-lo.
    if [ ! -f "$pul" ] || [ "$(find "$pul" -mmin +60)" ]; then
      checkupdates > "$pul" 2>/dev/null
    else
      # Se for recente, capturar quantas linhas o arquivo tem.
      package_value=$(cat "$pul" | wc -l)
    fi
}

# ==============================================================

get_package_count

case "$1" in
    icon)
        printf "%s\n" $package_icon
        ;;
    value)
        printf "%-d\n" $package_value
        ;;
    *)
        printf "%s %d\n" $package_icon $package_value
        ;;
esac

