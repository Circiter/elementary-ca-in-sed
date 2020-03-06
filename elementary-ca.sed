#!/bin/sed -Enf

# Written by Circiter (mailto:xcirciter@gmail.com)
# (Accessible as http://github.com/Circiter/elementary-ca-in-sed).
# Usage: echo <seed> | ./elementary-ca.sed
#        or echo auto | ./elementary-ca.sed.
# License: MIT.

# Rule 110 automaton

# Following block can be changes to something like
# /auto/s/^.*$/0000000000100000000000/.
/auto/{
    s/^.*$/0/; x

    # Unary reperesentation of a number n, so that an initial generation
    # will consist of 2^n zeros followed by 1 and finally by another 2^n zeros.
    s/^/xxxxxx/
    :repeat
        x; s/^.*$/&&/; x
        /^.$/!{s/^(.*).$/\1/; brepeat}
    x; s/^.*$/&1&/
}

s/[^01]/0/g
s/^/>00/; s/$/00\n/ # Treat the boundaries specially.

# Lookup table in the format {<bit_number>=<bit>;}*, where each
# bit is taken from the binary expansion of the rule number (in
# this case 110_{10}=01101110_2):
s/$/000=0;001=1;010=1;011=1;100=0;101=1;110=1;111=0/

# Uncomment one of the following lines to enjoy other automatons
# (or write your own lookup table for any other rule.)
#s/$/000=0;001=1;010=0;011=1;100=1;101=0;110=1;111=0/ # Rule 90.
#s/$/000=0;001=1;010=1;011=1;100=1;101=0;110=0;111=0/ # Rule 30.

# Pattern space: >seed\nlookup_table.

:generate
    h # Make backup [of the lookup table].
    # Both spaces: growing_generation>old_generation\nlookup_table.
    # Get next bit from the lookup-table and append this bit
    # to the generation being built.
    s/^([^>]*)>(...)([^\n]*)\n.*\2=(.).*$/\1\4>\2\3/

    s/>./>/ # Move the pointer (truncating the old generation).
    # Pattern space: growing_generation_updated>old_generation_truncated.

    x
    # Leave only the lookup table.
    s/^[^\n]*\n//
    x
    G # Restore the lookup table from the backup.

    />..\n/!bgenerate # Move the pointer as far as we can.

    # OK, new generation built successfully.

    # We stopped having two extra zeros after > and although there
    # is nevertheless some padding needed on the boundaries,
    # we remove one of them due to the fact that we have a
    # slightly shifted sequency, so it'll be better for compensate it
    # by extra zero but at the beginning.
    s/>.//; s/^/>0/ # Reinitialize the pointer marker.

    # Pretty printing.
    h; x; s/>([^\n]*)\n.*$/\1/; y/10/X /; p; x

    # Keep generating until we fill the bottom line completely.
    /^>01/!bgenerate

