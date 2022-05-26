/* checksum : 8fcc7d0606e2132443162ede88f7d3f4 */
@cds.persistence.skip : true
entity LockedVendorService.LockedVendors {
  key id : Integer;
  name : String(200);
  country : String(3);
  postalCode : String(20);
  currency : String(3);
};

@cds.external : true
service LockedVendorService {};

