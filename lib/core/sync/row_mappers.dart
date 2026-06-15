import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:vivocure/core/db/app_database.dart';

/// Server sync-payload row -> Drift companion mappers, shared by pull (page
/// apply) and push (server_row adoption after ack/conflict).
// ----------------------------------------------------------- companions

double? _toDouble(dynamic v) =>
    v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));
int? _toInt(dynamic v) =>
    v == null ? null : (v is num ? v.toInt() : int.tryParse('$v'));

DoctorsCompanion doctorCompanion(Map<String, dynamic> r) => DoctorsCompanion(
  id: Value(r['id'] as String),
  doctorCode: Value(r['doctor_code'] as String?),
  doctorType: Value(r['doctor_type'] as String?),
  firstName: Value(r['first_name'] as String?),
  middleName: Value(r['middle_name'] as String?),
  lastName: Value(r['last_name'] as String?),
  qualification: Value(r['qualification'] as String?),
  speciality: Value(r['speciality'] as String?),
  category: Value(r['category'] as String?),
  potential: Value(_toDouble(r['potential'])),
  supportValue: Value(_toDouble(r['support_value'])),
  expectedSupportValue: Value(_toDouble(r['expected_support_value'])),
  phone: Value(r['phone'] as String?),
  email: Value(r['email'] as String?),
  state: Value(r['state'] as String?),
  city: Value(r['city'] as String?),
  area: Value(r['area'] as String?),
  country: Value(r['country'] as String?),
  dob: Value(r['dob'] as String?),
  dom: Value(r['dom'] as String?),
  experienceYears: Value(_toInt(r['experience_years'])),
  chemistIds: Value(r['chemist_ids'] as String?),
  cdt: Value(r['cdt'] as String?),
  status: Value((r['status'] ?? 'active') as String),
  isEnabled: Value(r['is_enabled'] as bool? ?? true),
  serverUdt: Value(r['udt'] as String?),
  localStatus: const Value('synced'),
);

ChemistsCompanion chemistCompanion(Map<String, dynamic> r) => ChemistsCompanion(
  id: Value(r['id'] as String),
  chemistCode: Value(r['chemist_code'] as String?),
  fullName: Value((r['full_name'] ?? '') as String),
  phone: Value(r['phone'] as String?),
  email: Value(r['email'] as String?),
  contactPersonName: Value(r['contact_person_name'] as String?),
  contactPersonEmail: Value(r['contact_person_email'] as String?),
  contactPersonDob: Value(r['contact_person_dob'] as String?),
  contactPersonDom: Value(r['contact_person_dom'] as String?),
  state: Value(r['state'] as String?),
  city: Value(r['city'] as String?),
  area: Value(r['area'] as String?),
  country: Value(r['country'] as String?),
  potential: Value(_toDouble(r['potential'])),
  supportValue: Value(_toDouble(r['support_value'])),
  expectedSupportValue: Value(_toDouble(r['expected_support_value'])),
  cdt: Value(r['cdt'] as String?),
  status: Value((r['status'] ?? 'active') as String),
  isEnabled: Value(r['is_enabled'] as bool? ?? true),
  serverUdt: Value(r['udt'] as String?),
  localStatus: const Value('synced'),
);

ProductsCompanion productCompanion(Map<String, dynamic> r) {
  int? displayOrder;
  final dynamic meta = r['product_metadata'];
  if (meta is Map<String, dynamic>) {
    displayOrder = _toInt(meta['display_order']);
  }
  return ProductsCompanion(
    id: Value(r['id'] as String),
    productCode: Value(r['product_code'] as String?),
    productName: Value((r['product_name'] ?? '') as String),
    imageUrlsJson: Value(
      r['image_urls'] == null ? null : jsonEncode(r['image_urls']),
    ),
    primaryImageUrl: Value(r['primary_image_url'] as String?),
    productMetadataJson: Value(meta == null ? null : jsonEncode(meta)),
    displayOrder: Value(displayOrder),
    status: Value((r['status'] ?? 'active') as String),
    isEnabled: Value(r['is_enabled'] as bool? ?? true),
    serverUdt: Value(r['udt'] as String?),
    localStatus: const Value('synced'),
  );
}

DailyPlansCompanion planCompanion(Map<String, dynamic> r) =>
    DailyPlansCompanion(
      id: Value(r['id'] as String),
      userId: Value(r['user_id'] as String?),
      visitDate: Value((r['visit_date'] ?? '') as String),
      visitStatus: Value(_toInt(r['visit_status']) ?? 1),
      customerType: Value((r['customer_type'] ?? 'doctor') as String),
      customerId: Value((r['customer_id'] ?? '') as String),
      isTeamVisit: Value(r['is_team_visit'] as bool? ?? false),
      cdt: Value(r['cdt'] as String?),
      status: Value((r['status'] ?? 'active') as String),
      isEnabled: Value(r['is_enabled'] as bool? ?? true),
      serverUdt: Value(r['udt'] as String?),
      localStatus: const Value('synced'),
    );

DcrsCompanion dcrCompanion(Map<String, dynamic> r) => DcrsCompanion(
  id: Value(r['id'] as String),
  planId: Value(r['plan_id'] as String?),
  userId: Value(r['user_id'] as String?),
  visitDatetime: Value((r['visit_datetime'] ?? '') as String),
  remarks: Value(r['remarks'] as String?),
  supportValue: Value(_toDouble(r['support_value'])),
  potential: Value(_toDouble(r['potential'])),
  expectedSupportValue: Value(_toDouble(r['expected_support_value'])),
  productIds: Value(r['product_ids'] as String?),
  cdt: Value(r['cdt'] as String?),
  status: Value((r['status'] ?? 'active') as String),
  isEnabled: Value(r['is_enabled'] as bool? ?? true),
  serverUdt: Value(r['udt'] as String?),
  localStatus: const Value('synced'),
);

DcrProductRowsCompanion dcrProductCompanion(Map<String, dynamic> r) =>
    DcrProductRowsCompanion(
      id: Value(r['id'] as String),
      dcrId: Value(r['dcr_id'] as String?),
      productId: Value(r['product_id'] as String?),
      quantity: Value(_toInt(r['quantity']) ?? 0),
      feedback: Value(r['feedback'] as String?),
      status: Value((r['status'] ?? 'active') as String),
      isEnabled: Value(r['is_enabled'] as bool? ?? true),
      serverUdt: Value(r['udt'] as String?),
      localStatus: const Value('synced'),
    );
