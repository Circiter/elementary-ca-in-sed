# elementary-ca-in-sed

An attempt to implement one-dimensional elementary cellular automaton in sed.
This particular example shows how to implement the rule-110 ca. Edit the file
elementary-ca.sed to try out other rules (you can find rules 30 and 90 in
the source code or just write your own).

Usage examples:
```bash
echo auto | ./elementary-ca.sed
# Or
echo 000000000001 | ./elementary-ca.sed
```

TODO:
- Add decimal-to-binary converter to be able specify a rule number as
  the input to the script.
