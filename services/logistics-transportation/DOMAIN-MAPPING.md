# Logistics & Transportation Service

**Consolidated Services:**
- service-fleet-management
- service-tms (Transportation Management System)
- service-wms-advanced (Warehouse Management System)

## Domain Structure

### Fleet Management Domain (`fleet/`)
- **Models**: Vehicle, Driver, Route, Maintenance, FuelLog, FleetAsset, VehicleAssignment
- **Use Cases**: Fleet Operations, Vehicle Maintenance, Driver Management, Fleet Analytics
- **Infrastructure**: FleetRepository, MaintenanceService, DriverService, FleetTracker

### Transportation Management Domain (`tms/`)
- **Models**: Shipment, Carrier, TransportOrder, Delivery, RouteOptimization, FreightRate
- **Use Cases**: Shipment Planning, Carrier Management, Route Optimization, Delivery Tracking
- **Infrastructure**: ShipmentRepository, CarrierService, RouteOptimizer, DeliveryTracker

### Warehouse Management Domain (`wms/`)
- **Models**: Warehouse, Zone, Bin, PickList, PutAway, WarehouseTask, StockMovement
- **Use Cases**: Warehouse Operations, Pick/Pack/Ship, Inventory Placement, Task Management
- **Infrastructure**: WarehouseRepository, PickingService, TaskManager, MovementTracker

## Integration Points
- Fleet vehicles execute TMS planned routes
- WMS generates shipments for TMS processing
- Fleet maintenance affects TMS carrier capacity
- All domains share location and route data
