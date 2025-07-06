class APIResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  APIResponse({required this.success, this.data, this.error});

  factory APIResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return APIResponse(
      success: json['success'] as bool,
      data:
          json['data'] == null || fromJsonT == null
              ? (json['data']
                  as T?) // Allows for basic types or if no specific parser needed
              : fromJsonT(json['data']),
      error: json['error'] as String?,
    );
  }
}

class BaseData {
  final String? message;
  final int? id;

  const BaseData({this.message, this.id});

  factory BaseData.fromJson(Map<String, dynamic> json) {
    return BaseData(message: json['message'] as String?, id: json['id'] as int?);
  }
}
