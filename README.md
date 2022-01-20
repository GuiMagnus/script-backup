# script-backup
bash shell script for backup, restore and hash integrity check

# main script installation script and configuration file: install-GUILHERME.sh

./install-GUILHERME.sh

installs dependencies needed to run the script and sends the files to the specified directories within the script



# main script options: script-GUILHERME.sh

Options:

scriptname [-b]
scriptname [-r]
scriptname [-c]
scriptname [-h]


Option -b:

./script-GUILHERME.sh -b backs up the files mentioned in the script-GUILHERME.conf configuration file

Option -r:
./script-GUILHERME.sh -r backup-220102-1436.tar.bz2 directory/file_name directory/file_name 

restores the specified files passed as a parameter. Where the syntax applies:

./ScriptName -r CompressedFileName directory/FileName...

Where several directories can be passed for restoration

Option -c:
./script-GUILHERME.sh -c backup-220102-1436.tar.bz2 Realiza a verificação de integridade do hash salvo no arquivo de log

Onde a sintaxe se aplica:

./nomeScript -c nomeArquivoCompactado

