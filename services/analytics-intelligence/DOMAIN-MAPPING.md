# Analytics & Intelligence Service

**Consolidated Services:**
- service-analytics-data-products
- service-ai-ml
- service-reporting-analytics

## Domain Structure

### Analytics Data Products Domain (`data-products/`)
- **Models**: DataProduct, Dataset, DataPipeline, DataSchema, DataQuality, DataLineage
- **Use Cases**: Data Product Management, Pipeline Orchestration, Data Quality Monitoring
- **Infrastructure**: DataRepository, PipelineEngine, QualityMonitor, LineageTracker

### AI/ML Domain (`ai-ml/`)
- **Models**: MLModel, Training, Prediction, FeatureStore, Experiment, ModelRegistry
- **Use Cases**: Model Training, Inference, Feature Engineering, Experiment Management
- **Infrastructure**: MLRepository, TrainingEngine, InferenceService, FeatureStore

### Reporting & Analytics Domain (`reporting/`)
- **Models**: Report, Dashboard, KPI, Metric, ReportTemplate, AnalyticsQuery
- **Use Cases**: Report Generation, Dashboard Management, KPI Tracking, Business Intelligence
- **Infrastructure**: ReportRepository, DashboardService, KPICalculator, QueryEngine

## Integration Points
- AI/ML models consume data from Data Products
- Reporting uses both raw data and ML predictions
- All domains share common metadata and lineage
- Cross-domain analytics for business insights
