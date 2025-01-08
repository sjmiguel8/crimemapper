import 'ckan_api_service.dart';
import '../models/crime_report.dart';

class CrimeService {
  final CkanApiService _api = CkanApiService();
  
  // First, let's get the dataset structure
  Future<void> initialize() async {
    try {
      // Get dataset info to verify it exists and get resource IDs
      final datasetInfo = await _api.getDatasetInfo(CkanApiService.crimeDatasetId);
      print('Dataset info: $datasetInfo');
      
      // Get the first resource's structure
      if (datasetInfo['resources']?.isNotEmpty) {
        final resourceId = datasetInfo['resources'][0]['id'];
        final structure = await _api.getResourceInfo(resourceId);
        print('Resource structure: $structure');
      }
    } catch (e) {
      print('Initialization error: $e');
      rethrow;
    }
  }

  Future<List<CrimeReport>> getCrimeReports({
    String? query,
    int limit = 100,
    int offset = 0,
    String? sortField,
    bool sortAscending = true,
  }) async {
    try {
      // Get the first page of results
      final result = await _api.searchResource(
        resourceId: CkanApiService.crimeDatasetId,
        query: query,
        limit: limit,
        offset: offset,
        sort: sortField != null 
          ? '${sortField} ${sortAscending ? 'asc' : 'desc'}'
          : null,
      );

      final records = result['records'] as List;
      return records.map((record) => CrimeReport.fromJson(record)).toList();
    } catch (e) {
      print('Error fetching crime reports: $e');
      rethrow;
    }
  }
} 