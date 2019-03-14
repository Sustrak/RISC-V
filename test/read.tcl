set master [claim_service "master" [lindex [get_service_paths "master"] 0] ""]; 
master_write_from_file $master C:/Users/Panoramix/Documents/RISCV/test/stld.bin 32
puts stdout [master_read_32 $master 32 1]
