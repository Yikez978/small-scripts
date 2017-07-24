#got this idea from sean metcalf's awesome article titled "Mimikatz DCSync Usage, Exploitation, and Detection"
#reference: https://adsecurity.org/?p=1729


#this is where you would place your domain controllers 
const domain_controllers: set[addr] = {
} &redef;

#uuid is not necessary, just added it to be more focused of a signature
event dce_rpc_request(c: connection, fid: count, opnum: count, stub_len: count)
{
  if (c$id$orig_h !in domain_controllers && c$dce_rpc_state?$uuid && 
      c$dce_rpc_state$uuid == "e3514235-4b06-11d1-ab04-00c04fc2dcd2" && c$dce_rpc?$operation 
      && c$dce_rpc$operation == "DRSGetNCChanges")
  {
     print fmt("%s --> %s ---- Replication from an unauthorized address ----", c$id$orig_h, c$id$resp_h);
  }
}
