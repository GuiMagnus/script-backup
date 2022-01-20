#!/bin/bash

dataFormatada=`date +%y%m%d-%H%M`
arquivoConf=/etc/script-GUILHERME.conf
arquivoLog=$(egrep "log" $arquivoConf | sed 's/.*://')
destinoBackup=$(grep "destino_backup:" $arquivoConf | sed 's/.*://')
arqLog="backup-GUILHERME.log"
caminhoCompletoLog=$arquivoLog$arqLog
if [ ! -d $destinoBackup ]
then
	mkdir -p $destinoBackup
	if [ $? -ne 0 ]
	then
		echo "Este usuário não possui permissões para criar um diretório de destino para o backup"
	fi
fi

if [  ! -d $arquivoLog ]
then
	mkdir -p $arquivoLog
	if [ $? -ne 0 ]
	then
		echo "Você não tem permissões para criar um diretório de log!"
		exit 1
	fi
fi

if [ ! -f $arquivoLog$arqLog ]
then
	touch $arquivoLog$arqLog
	if [ $? -ne 0 ]
	then
		echo "Este usuário não possui permissões para criar um arquivo de log"
		exit 1
	fi
		
fi

if [ $1 = -b ] > /dev/null 2>&1
then
	if [ $# -le 1 ]
	then
		echo "Execução do backup - $dataFormatada" > /dev/null 2>&1 >> $caminhoCompletoLog
		if [ $? -ne 0 ]
		then
			echo "Este usuário não possui permissões para executar esse script!"
			exit 1
		fi
		echo "Horário de início - `date +%HH:%MM:%ss`" >> $caminhoCompletoLog
		echo "Arquivos inseridos no backup:" >> $caminhoCompletoLog
		diretorios=''
		while IFS= read -r linha || [[ -n "$linha" ]]; do
			if [ -d "$linha" ] && [ $linha != "destino_backup:"$destinoBackup ]
			then
				diretorios+="$linha* "
				echo "Diretório $linha encontrado... Realizando backup "
			fi
		done < "$arquivoConf"
		tar -cvzf $destinoBackup"backup-"$dataFormatada.tar.bz2 $diretorios > /dev/null 2>&1 >> $caminhoCompletoLog
		
	echo "Arquivo gerado: $destinoBackup"backup-"$dataFormatada.tar.bz2" >> $caminhoCompletoLog
	echo "Hash sha256 do arquivo.bz2: $(sha256sum $destinoBackup"backup-"$dataFormatada.tar.bz2)" >>$caminhoCompletoLog

	echo "Horário da finalização do backup: - `date +%HH:%MM:%ss`" >> $caminhoCompletoLog
	echo "*********************************************************************" >> $caminhoCompletoLog
	else
		echo "Número de parâmetros inválidos! Consulte nomeScript.sh -h"
	fi
elif [ $1 = -r ] > /dev/null 2>&1
then
	if [ $# -gt 2 ]
	then
		if [ -f $2 ]
		then
			diretorios=''
			for valor in $*
			do
				if [ $valor != $1 ] && [ $valor != $2 ]
				then
					#diretorios+=$valor" "
					$(tar -C / -xf $2 $valor > /dev/null 2>&1 )
					if [ $? = 0 ]
					then
						echo "Restauração do diretório $valor concluída com sucesso!"
					else
						echo "Diretório $valor inexistente!"
					fi
				fi
			done
		else
			echo "É necessário que o segundo parâmetro seja um arquivo .tar.bz2 existente"
		fi
	else
		> /dev/null
		echo "São necessários diretórios para restauração!"	
	fi
	elif [ $1 = -c ] > /dev/null 2>&1
	then	
		if [ $# -lt 3 ]
		then
			if [ $# -gt 1 ] && [ -f "$2" ]
			then
				hashLog=$(egrep "$2" $arquivoLog | cut -d" " -f5)
				hashArquivo=$(sha256sum $2 | cut -f 1 -d ' ') 
				if [ $hashLog = $hashArquivo ]
				then
					echo "Arquivo está íntegro"
				else
					> /dev/null 2>&1
					echo "Não está íntegro"
				fi
			else
				> /dev/null
				echo "É necessário o caminho de um arquivo.tar.bz2 existente!"
			fi
		else
			echo "Número de parâmetros inválidos! Consulte nomeScript.sh -h"
		fi
	else
		> /dev/null 2>&1
		echo "
		O Script de backup possui 3 funções:
		
		nomeArquivo -b
		nomeArquivo -r arquivoCompactado.tar.bz2 listaDeDiretoriosParaRestauracao
		nomeArquivo -c caminhoArquivoBackup
		
		Onde a opção -b realiza o backup de diretórios informados no arquivo .conf
		Ex: ./scriptNome.sh -b
		
		A opção -r realiza a restauração dos diretórios passados como parâmetro
		parâmetros necessários: 

		-arquivo.tar.bz2  #Contém um backup de diretórios.
		-nomeDiretorio/nomeArquivo #caminho do arquivo a ser restaurado.

		ex: script-GUILHERME.sh -r /destinoArquivoBackup/backup-211217-14:36.tar.bz2 
		spool/nomeArquivo etc/nomeArquivo
		
		DETALHE: Não é necessário informar o diretório raíz / dos diretórios de origem.
		O arquivo.tar.bz2 é necessário informar a / ou seja, o caminho completo do .tar.bz2
		
		A opção -c realiza a checagem de integridade do arquivo
	       	passado como parâmetro e o arquivo a que se referencia

		ex: script-GUILHERME.sh /destino/backup-20211217-14:36.tar.bz2"
fi
