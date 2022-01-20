#!/bin/bash

arquivoPrincipal="script-GUILHERME.sh"
arquivoConf="script-GUILHERME.conf"
diretorioPrincipal="/usr/sbin/"
diretorioConf="/etc/"

echo "PEI!"
if [[ $EUID -ne 0 ]]; then
	echo "Permissão negada! Deve ser executado como root!"
	exit 1
fi

echo "Instalando pacotes necessários..."
yum install tar -y > /dev/null
yum install bzip2 -y > /dev/null
#yum install sha256 -y > /dev/null
if [ -f $arquivoPrincipal ]
then
	if [ -f $arquivoConf ]
	then
		if [ -d $diretorioPrincipal ]
		then
			if [ -d $diretorioConf ]
			then
				echo "PEI DENOVO"
				cp $arquivoPrincipal $diretorioPrincipal
				cp $arquivoConf $diretorioConf
				echo "script instalado com sucesso!"
			else
				echo "Diretório do arquivo de configuração inexistente!"
			fi
		else
			echo "Diretório do script principal inexistente!"
		fi
	else
		echo "Arquivo de configuração não está presente neste diretório!"
	fi
else
	echo "Arquivo do script principal não está presente neste diretório!"
fi

