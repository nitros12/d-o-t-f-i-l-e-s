# Simple
# https://github.com/sotayamashita/simple
#
# MIT © Sota Yamashita

function __git_upstream_configured
    git rev-parse --abbrev-ref @"{u}" > /dev/null 2>&1
end

function __print_color
    set -l color  $argv[1]
    set -l string $argv[2]

    set_color $color
    printf $string
    set_color normal
end

function fish_prompt -d "Simple Fish Prompt"
    echo -e ""

    # User
    #
    set -l user (id -un $USER)
    __print_color 596196 "$user"


    # Host
    #
    set -l host_name (hostname -s)
    set -l host_glyph " at "

    __print_color EDEFF2 "$host_glyph"
    __print_color 6673BF "$host_name"


    # Current working directory
    #
    set -l pwd_glyph " in "
    set -l pwd_string (echo $PWD | sed 's|^'$HOME'\(.*\)$|~\1|')

    __print_color EDEFF2 "$pwd_glyph"
    __print_color 31658C "$pwd_string"


    # Git
    #
    if git_is_repo
        set -l branch_name (git_branch_name)
        set -l git_glyph " on "
        set -l git_branch_glyph

        __print_color EDEFF2 "$git_glyph"
        __print_color 3EA290 "$branch_name"

        if git_is_touched
            if git_is_staged
                if git_is_dirty
                    set git_branch_glyph " [±]"
                else
                    set git_branch_glyph " [+]"
                end
            else
                set git_branch_glyph " [?]"
            end
        end

        __print_color 8292B2 "$git_branch_glyph"

        if __git_upstream_configured
             set -l git_ahead (command git rev-list --left-right --count HEAD...@"{u}" ^ /dev/null | awk '
                $1 > 0 { printf("⇡") } # can push
                $2 > 0 { printf("⇣") } # can pull
             ')

             if test ! -z "$git_ahead"
                __print_color 8292B2 " $git_ahead"
            end
        end
    end

    __print_color 95A7CC "\e[K\n:: "
end
