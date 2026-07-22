#!/bin/bash
# EDL tool wrapper for Tukzer WM3311
# Usage: ./edl.sh rf backup.bin  (full read backup)
#        ./edl.sh rl partitions --genxml  (partition-level backup)
# Requires: bkerler/edl installed

python3 -c "
try:
    import edlclient
    print('EDL library found')
except ImportError:
    print('EDL not installed. Install with:')
    print('  git clone https://github.com/bkerler/edl.git')
    print('  cd edl && pip install .')
    exit(1)
" 2>/dev/null

exec python3 -m edlclient.edl "$@"
