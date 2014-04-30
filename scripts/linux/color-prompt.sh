# This is from the Archlinux wiki

# Bash allows these prompt strings to be customized by inserting a
# number of backslash-escaped special characters that are
# decoded as follows:
#
#   \a    an ASCII bell character (07)
#   \d    the date in "Weekday Month Date" format (e.g., "Tue May 26")
#   \D{format}  the format is passed to strftime(3) and the result
#         is inserted into the prompt string an empty format
#         results in a locale-specific time representation.
#         The braces are required
#   \e    an ASCII escape character (033)
#   \h    the hostname up to the first `.'
#   \H    the hostname
#   \j    the number of jobs currently managed by the shell
#   \l    the basename of the shell's terminal device name
#   \n    newline
#   \r    carriage return
#   \s    the name of the shell, the basename of $0 (the portion following
#         the final slash)
#   \t    the current time in 24-hour HH:MM:SS format
#   \T    the current time in 12-hour HH:MM:SS format
#   \@    the current time in 12-hour am/pm format
#   \A    the current time in 24-hour HH:MM format
#   \u    the username of the current user
#   \v    the version of bash (e.g., 2.00)
#   \V    the release of bash, version + patch level (e.g., 2.00.0)
#   \w    the current working directory, with $HOME abbreviated with a tilde
#   \W    the basename of the current working directory, with $HOME
#        abbreviated with a tilde
#   \!    the history number of this command
#   \#    the command number of this command
#   \$    if the effective UID is 0, a #, otherwise a $
#   \nnn    the character corresponding to the octal number nnn
#   \\    a backslash
#   \[    begin a sequence of non-printing characters, which could be used
#         to embed a terminal control sequence into the prompt
#   \]    end a sequence of non-printing characters
#
#   The command number and the history number are usually different:
#   the history number of a command is its position in the history
#   list, which may include commands restored from the history file
#   (see HISTORY below), while the command number is the position in
#   the sequence of commands executed during the current shell session.
#   After the string is decoded, it is expanded via parameter
#   expansion, command substitution, arithmetic expansion, and quote
#   removal, subject to the value of the promptvars shell option (see
#   the description of the shopt command under SHELL BUILTIN COMMANDS
#   below).

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White

bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White

unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White

bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

# Extended colors
fulblu='\e[1;38;5;39m'
fulgre='\e[1;38;5;242m'
fulgre2='\e[1;38;5;247m'

export TERM=xterm-256color
export PS1="\[$fulblu\]hackademy\[$fulgre\]@\[$fulgre2\]\h \[$bldwht\]\w \[$fulblu\]\$\[$txtrst\] "

# TODO
# Set the terminal (gnome-terminal) background to #303030 and foreground to white
# The font used is Source Code Pro Medium (from Adobe) 13pt.
# The size of the window is 130 cols / 32 rows
