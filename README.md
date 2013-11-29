[[!template id=plugin name=cowsay author="[[BrianCandler]]"]]
[[!tag type/fun]]

This plugin provides the [[ikiwiki/directive/cowsay]] [[ikiwiki/directive]].
This directive allows creation of ASCII-art cows.

For example,

~~~
\[[!cowsay state="stoned" text="""
moo tube!
"""]]
~~~

renders as

~~~
 ___________
< moo tube! >
 -----------
        \   ^__^
         \  (**)\_______
            (__)\       )\/\
             U  ||----w |
                ||     ||
~~~

You must have the [cowsay](https://en.wikipedia.org/wiki/Cowsay) package
installed.
