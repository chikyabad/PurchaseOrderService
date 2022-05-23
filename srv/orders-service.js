const cds = require('@sap/cds');

module.exports = async function () {

    const db = await cds.connect.to('db'), { PurchaseOrders, PurchaseOrdersLines } = db.entities;

    this.before('CREATE', 'PurchaseOrders', async (req) => {
        req.data.status = 'New';
    });

    this.on('getOrdersByStatus', async req => {

        // Open transaction
        const tx = await cds.tx(req);

        // Get parameters
        let params = req.data;

        // Get puchase orders details
        let purchaseOrders = await tx.run(SELECT.from(PurchaseOrders).where({ status: params.status }));

        if(!purchaseOrders){
            return req.reject(404);
        }

        return purchaseOrders;

    })

    this.on('setOrderStatus', async req => {

        // Open transaction
        const tx = await cds.tx(req);

        // Get passed data
        let data = req.data;

        // Check status
        var statuses = ["New", "Active", "Completed", "Cancelled"];
        if (!statuses.includes(data.status)) {
            return req.reject(400, `Status ${data.status} is not a valid value`);
        }

        // Update status
        let result = await tx.run(UPDATE(PurchaseOrders, data.id).with({ status: data.status }));
        if (result == 0) {
            // Order not found
            return req.reject(404, `Purchase Order with ID ${data.id} not found`);
        }

        return tx.run(SELECT.one.from(PurchaseOrders).where({ ID: data.id }));

    });

}