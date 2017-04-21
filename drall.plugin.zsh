#compdef drall

_drall_matchers() {
    values=$(find /usr/share/drall/match-tests -type f -printf "%f\n")
}

_drall() {
    #_drall_arglist=\
    #    '-m[Matchers]:matcher:->matchers' \
    #    '--name':'[Name filter]' \
    #    '-r':'[Exec as root]' \
    #    '-v':"Verbose" \
    #    '-q':"[Quiet]" \
    

    #_arguments \
    #    '*:: :->commands' && return 0

    _arguments '-m:: :->matchers'
    #_arguments $_drall_arglist
    
    #_describe -t commands "drall commands" _drall_arglist
    
    #if (( CURRENT == 1 )); then
    #    _describe -t commands "drall commands" _drall_arglist
    #    return
    #fi
    
    case $state in
        matchers)
        _drall_matchers
        compadd "$@" $(echo $values)
        ;;

        *)
        _files
        ;;
    esac


}

compdef _drall drall
