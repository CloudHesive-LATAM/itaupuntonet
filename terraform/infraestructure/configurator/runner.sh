{ result_stderr=$(python3 runner.py 2>&1); }
echo $result_stderr | tr "," "\n"