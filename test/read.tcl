set srv [claim_service "master" [lindex [get_service_paths "master"] 0] ""]; 
master_read_32 $srv 0x400000 1
