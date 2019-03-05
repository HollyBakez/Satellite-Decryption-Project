struc   satMessage                             
  Id                         resb 4       ;  0 
  NodeName                   resb 8       ;  4 
  NodeNumber                 resd 1       ; 12 
  tx_packet_nbr              resd 1       ; 16 
  rx_packet_nbr              resd 1       ; 20 
  track_object_nbr           resd 1       ; 24 
  track_object_x_pos         resd 1       ; 28 
  track_object_y_pos         resd 1       ; 32 
  track_object_z_pos         resd 1       ; 36 
  track_object_velocity      resd 1       ; 40 
  status_code                resd 1       ; 44 
  msg_length                 resb 1       ; 48 
  status_msg                 resb 128     ; 49 
endstruc                                       
