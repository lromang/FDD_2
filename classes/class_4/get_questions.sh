#! /bin/bash

# ----------------------------------------
# Get questions
# ========================================
#
# This script downloads (in case it doesn't
# exist) the html from the front page at
# https://stackexchange.com
# subsequently it calls a sed script that
# parses the questions and outputs the
# result to a user given file
# (defaults questions.txt)
# ----------------------------------------

output_file="${1:-questions.txt}"

if [[ ! -f stack_exchange.txt ]]
then
    curl https://stackexchange.com/ > stack_exchange.txt
fi

gsed -nEf q_parser stack_exchange.txt | tr '\n' ',' > $output_file
