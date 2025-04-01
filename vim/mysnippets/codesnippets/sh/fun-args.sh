copy() {
    local from to

    while [[ ${1} ]]; do
        case "${1}" in
            --from)
                from=${2}
                shift
                ;;
            --to)
                to=${2}
                shift
                ;;
            *)
                echo "Unknown parameter: ${1}" >&2
                return 1
        esac

        if ! shift; then
            echo 'Missing parameter argument.' >&2
            return 1
        fi
    done
}

copy --from /tmp/a --to /tmp/b