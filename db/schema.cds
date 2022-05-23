namespace cac.training.procurement;

using {
    managed,
    cuid
} from '@sap/cds/common';

@cds.persistence.exists
entity Vendors {
    key id             : Integer;
        name           : String(200);
        country        : String(3);
        postalCode     : String(20);
        currency       : String(3);
        products       : Composition of many Products
                             on products.vendor = $self;
        purchaseOrders : Association to many PurchaseOrders
                             on purchaseOrders.vendor = $self;
}

@cds.persistence.exists
entity Products {
    key id        : Integer;
        name      : String;
        unitPrice : Decimal;
        vendor    : Association to Vendors;
}

entity PurchaseOrders : managed, cuid {
    vendor : Association to Vendors;
    status : String(50)
        @assert.range enum {
            New;
            Active;
            Completed;
            Cancelled
        };
    lines  : Composition of many PurchaseOrdersLines
                 on lines.purchaseOrder = $self;
}

@assert.unique: {
  purchaseOrderLine: [ purchaseOrder, line ]
}
entity PurchaseOrdersLines : managed, cuid {
    purchaseOrder : Association to PurchaseOrders;
    line          : Integer;
    product       : Association to Products;
    quantity      : Decimal;
    price         : Decimal;
}