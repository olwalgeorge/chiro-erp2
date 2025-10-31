# Supply Chain & Manufacturing Service

**Consolidated Services:**
- service-mrp-production
- service-quality-management
- service-inventory-management

## Domain Structure

### MRP Production Domain (`production/`)
- **Models**: ProductionOrder, BOM, WorkCenter, RoutingStep, ManufacturingResource, ProductionSchedule
- **Use Cases**: Production Planning, MRP Calculation, Production Execution, Resource Planning
- **Infrastructure**: ProductionRepository, MRPEngine, SchedulingService, ResourceManager

### Quality Management Domain (`quality/`)
- **Models**: QualityPlan, Inspection, QualityTest, NonConformance, CAPA, QualityMetric
- **Use Cases**: Quality Planning, Inspection Management, Non-conformance Handling, Quality Analytics
- **Infrastructure**: QualityRepository, InspectionService, CAPAProcessor, QualityAnalytics

### Inventory Management Domain (`inventory/`)
- **Models**: Item, Stock, Location, Movement, StockLevel, Reservation, StockAdjustment
- **Use Cases**: Stock Management, Inventory Tracking, Location Management, Stock Movements
- **Infrastructure**: InventoryRepository, StockService, LocationService, MovementTracker

## Integration Points
- Production consumes inventory based on BOM requirements
- Quality inspections affect inventory availability
- Production completion updates inventory levels
- All domains share common Item master data
