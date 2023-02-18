

awk '/>/ {
    if ($3=="sp.") print $1,$2,$3,$4; else if ($3=="muscaria" && ($4=="var." || $4=="subsp.")) print $1,$2,$3,$4,$5; else print $1,$2,$3
    }' ${1}