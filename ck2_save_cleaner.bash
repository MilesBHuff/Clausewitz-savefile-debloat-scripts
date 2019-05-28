#!/usr/bin/env bash
## This script removes unnecessary information from uncompressed .ck2 files.
## This will decrease filesize and can speed up the game.

## Check params
if [[ ! -f "$1" ]]; then
	echo 'Please provide the path to an uncompressed .ck2 file as the parameter for this script.' >&2
	exit 1
fi

## Aliases
alias cp='cp -f'
alias mv='mv -f'

## Functions
function regex {
	perl -i -0777 -pe "$1" < "$F1" > "$F2" 2> /dev/null
	mv "$F2" "$F1"
}

## Set up working files
while [[ "$F1" = "$F2" || -f "$F1" || -f "$F2" ]]; do
	F1="/tmp/$((9999 + RANDOM % 99999999)).ck2"
	F2="/tmp/$((9999 + RANDOM % 99999999)).ck2"
done
cp "$1" "$F1"

## -----------------------------------------------------------------------------
HEADER='General'

echo "$HEADER: Blanking negative dates..."
regex 's/  -\d*\.\d{1,2}\.\d{1,2}  //gmsx'

echo "$HEADER: Removing empty strings..."
regex 's/  ^.*""  //gmx'  ## No 's'

echo "$HEADER: Removing 'noreligion'..."
regex 's/  \t*       rel(|igion)="noreligion"\n  //gmsx'
#regex 's/  \t*(original_|)parent="noreligion"\n  //gmsx'

#echo "$HEADER: Removing 'was_heresy'..."
regex 's/  \t*was_heresy=(yes|no)\n  //gmsx'

echo "$HEADER: Removing technology..." #NOTE:  Only for use with mods that don't use tech!
regex 's/  \t{3}technology=.*?\t{3}\}\n  //gmsx'

## -----------------------------------------------------------------------------
HEADER='Characters'

echo "$HEADER: Removing 'hist'..." ## This is just whether a character is historical.  Not really important.
regex 's/            \t* hist=[^\n\t]*?  \n  //gmsx'

#echo "$HEADER: Removing 'pi'..."  ## This is whether a character is ???.  Probably not important?
#regex 's/            \t*   pi=[^\n\t]*?  \n  //gmsx'

echo "$HEADER: Removing stats from the deceased..."
regex 's/  d_d.*?\K  \t{3}att=[^\n\t]*?\}\n  //gmsx'

## -----------------------------------------------------------------------------
HEADER='Inactive titles'

echo "$HEADER: Removing laws..."
regex 's/                  \t{3}                 succession= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}                     gender= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}                        law= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3} set_protected_inheritance = [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3} set_appoint_generals      = [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3} set_allow_title_revokation= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}allows_matrilineal_marriage= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3} set_investiture           = [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/  active=no.*?\K  \t{3}             council_voting=.*?\n\t{3}\}\n  (?=   .*\t{2}\})                               //gmsx'

echo "$HEADER: Removing dates and timeouts..."
regex 's/                  \t{3}           succ_law_changer= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}        de_jure_law_changer= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}        de_jure_law_change = [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}        de_jure_law_changes= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}         normal_law_changer= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}         normal_law_change = [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/                  \t{3}               last_change = [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/  active=no.*?\K  \t{3}              law_vote_date= [^\n\t]*?  \n  (?=   .*\t{2}\})                               //gmsx'
regex 's/  active=no.*?\K  \t{3}         law_change_timeout= [^\n\t]*?  \n  (?=   .*\t{2}\})                               //gmsx'
regex 's/  active=no.*?\K  \t{3}   crown_law_change_timeout= [^\n\t]*?  \n  (?=   .*\t{2}\})                               //gmsx'

echo "$HEADER: Removing misc..."
regex 's/                  \t{3}            holding_dynasty= [^\n\t]*?  \n  (?=  (?:\t{3,}[^\n\t]*?\n)*?  \t{3}active=no)  //gmsx'
regex 's/  active=no.*?\K  \t{3}           conquest_culture= [^\n\t]*?  \n  (?=   .*\t{2}\})                               //gmsx'
regex 's/  active=no.*?\K  \t{3}                       vars=.*?\n\t{3}\}\n  (?=   .*\t{2}\})                               //gmsx'
regex 's/  active=no.*?\K  \t{3}                         et= [^\n\t]*?  \n  (?=   .*\t{2}\})                               //gmsx'

## -----------------------------------------------------------------------------
HEADER='Diseases'

echo "$HEADER: Wiping outbreak timeouts..."
regex 's/  \n\t{1}dont_break_out_again_entity=.*?\n\t{1}\}  //gmsx'

echo "$HEADER: Wiping general outbreak history..."    ## Possible to target only inactive diseases
regex 's/  \n\t{1}   disease_outbreak        =.*?\n\t{1}\}  //gmsx'

echo "$HEADER: Wiping provincial outbreak history..." ## Not possible to target only inactive diseases
regex 's/  \n\t{3}   disease                 =.*?\n\t{3}\}  //gmsx'

## -----------------------------------------------------------------------------
HEADER='Minification'

echo "$HEADER: Removing tabs..."
regex 's/  \t        //gmsx'

echo "$HEADER: Removing unnecessary newlines..."
regex 's/  \n{2,}  /\n/gmsx'
regex 's/  \n\{    /\{/gmsx'

echo "$HEADER: Condensing spaces..."
regex 's/  \ {2,}   / /gmsx'

## -----------------------------------------------------------------------------
echo "Saving cleaned file..."
mv "$F1" "$(echo $1 | cut -f 1 -d .)_cleaned.ck2"
exit 0
