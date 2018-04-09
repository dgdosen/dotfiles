c() { cd ~/dev/$1; }
_c() { _files -W ~/dev -/; }

compdef _c c

cg() { cd $GOPATH/src/github.com/dgdosen/$1; }
_cg() { _files -W $GOPATH/src/github.com/dgdosen -/; }

compdef _cg cg

time_files() { cd ~/pdropbox/_my.documents/data.business/dosen_financial/time/$1; }
_time_files() { _files -W ~/pdropbox/_my.documents/data.business/dosen_financial/time -/; }

compdef _time_files time_files

tps() { vim ~/pdropbox/_my.documents/data.business/dosen_financial/time/$1; }
_tps() { _files -W ~/pdropbox/_my.documents/data.business/dosen_financial/time -/; }

compdef _tps tps

