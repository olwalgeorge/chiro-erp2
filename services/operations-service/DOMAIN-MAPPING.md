# Operations & Service Management Service

**Consolidated Services:**
- service-field-service-management
- service-resource-scheduling
- service-records-management
- service-repair-rma

## Domain Structure

### Field Service Management Domain (`field-service/`)
- **Models**: ServiceOrder, WorkOrder, Technician, ServiceLocation, Equipment, ServiceReport
- **Use Cases**: Service Order Management, Technician Dispatch, Equipment Tracking, Service Execution
- **Infrastructure**: ServiceOrderRepository, TechnicianLocationService, EquipmentService

### Resource Scheduling Domain (`scheduling/`)
- **Models**: Schedule, Resource, Appointment, TimeSlot, Calendar, Availability, Booking
- **Use Cases**: Resource Allocation, Appointment Scheduling, Calendar Management, Availability Planning
- **Infrastructure**: SchedulingRepository, CalendarService, ResourceOptimizer

### Records Management Domain (`records/`)
- **Models**: ServiceRecord, Document, ServiceHistory, MaintenanceLog, ComplianceRecord
- **Use Cases**: Service Documentation, History Tracking, Compliance Management, Audit Trail
- **Infrastructure**: DocumentRepository, HistoryService, ComplianceTracker

### Repair & RMA Domain (`repair-rma/`)
- **Models**: RepairOrder, RMA, WarrantyCase, RepairStatus, ReturnAuthorization, RepairPart
- **Use Cases**: Repair Management, RMA Processing, Warranty Claims, Return Authorization
- **Infrastructure**: RepairRepository, WarrantyService, PartsService

## Integration Points
- Service Orders trigger Resource Scheduling
- Scheduled appointments generate Service Records
- Field Service work may result in Repair/RMA cases
- All domains share common Resource and Location data
