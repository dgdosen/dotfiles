c() { cd ~/Development/$1; }
_c() { _files -W ~/Development -/; }
compdef _c c
tps() { cd ~/pdropbox/_my.documents/data.business/dosen_financial/time/$1; }
_tps() { _files -W ~/pdropbox/_my.documents/data.business/dosen_financial/time -/; }
compdef _tps tps
