using {cac.training.procurement as schema} from '../db/schema';

@path : '/purchase-orders-service'
service PurchaseOrderService {
    
    @readonly
    entity Vendors as projection on schema.Vendors;

    @readonly
    entity Products as projection on schema.Products;

    entity PurchaseOrders as projection on schema.PurchaseOrders;

    function getOrdersByStatus(status : String(50))         returns array of PurchaseOrders;
    
    action   setOrderStatus(id : UUID, status : String(50)) returns PurchaseOrders;
    
}
