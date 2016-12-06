c() { cd ~/dev/$1; }
_c() { _files -W ~/dev -/; }

compdef _c c

time_files() { cd ~/pdropbox/_my.documents/data.business/dosen_financial/time/$1; }
_time_files() { _files -W ~/pdropbox/_my.documents/data.business/dosen_financial/time -/; }

compdef _time_files time_files

tps() { vim ~/pdropbox/_my.documents/data.business/dosen_financial/time/$1; }
_tps() { _files -W ~/pdropbox/_my.documents/data.business/dosen_financial/time -/; }

compdef _tps tps

