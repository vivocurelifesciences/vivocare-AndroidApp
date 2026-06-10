import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/sync/outbox_service.dart';
import 'package:vivocure/data/repositories/chemist_repository.dart';
import 'package:vivocure/data/repositories/dcr_repository.dart';
import 'package:vivocure/data/repositories/doctor_repository.dart';
import 'package:vivocure/data/repositories/plan_repository.dart';

void main() {
  late AppDatabase db;
  late OutboxService outbox;

  setUp(() {
    db = AppDatabase.forTesting();
    outbox = OutboxService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('OutboxService', () {
    test('enqueue then coalesce keeps single op with latest payload', () async {
      await outbox.enqueue(
        entity: 'doctors',
        entityId: 'd1',
        op: 'create',
        payload: <String, dynamic>{'first_name': 'A'},
      );
      await outbox.enqueue(
        entity: 'doctors',
        entityId: 'd1',
        op: 'update',
        payload: <String, dynamic>{'first_name': 'B'},
      );

      final ops = await outbox.nextBatch();
      expect(ops, hasLength(1));
      // create + update coalesce into the original create with newest state
      expect(ops.single.op, 'create');
      expect(jsonDecode(ops.single.payloadJson)['first_name'], 'B');
    });

    test('create then delete cancels out entirely', () async {
      await outbox.enqueue(
        entity: 'doctors',
        entityId: 'd1',
        op: 'create',
        payload: <String, dynamic>{'first_name': 'A'},
      );
      await outbox.enqueue(
        entity: 'doctors',
        entityId: 'd1',
        op: 'delete',
        payload: const <String, dynamic>{},
      );
      expect(await outbox.nextBatch(), isEmpty);
    });

    test('update then delete becomes delete', () async {
      await outbox.enqueue(
        entity: 'dcr',
        entityId: 'x1',
        op: 'update',
        payload: <String, dynamic>{'remarks': 'r'},
      );
      await outbox.enqueue(
        entity: 'dcr',
        entityId: 'x1',
        op: 'delete',
        payload: const <String, dynamic>{},
      );
      final ops = await outbox.nextBatch();
      expect(ops.single.op, 'delete');
    });

    test('inflight ops recover to pending (crash mid-push)', () async {
      await outbox.enqueue(
        entity: 'doctors',
        entityId: 'd1',
        op: 'create',
        payload: const <String, dynamic>{},
      );
      final ops = await outbox.nextBatch();
      await outbox.markInflight(ops);
      expect(await outbox.nextBatch(), isEmpty);

      await outbox.recoverInflight();
      expect(await outbox.nextBatch(), hasLength(1));
    });

    test('repeated failures park the op as conflict', () async {
      await outbox.enqueue(
        entity: 'doctors',
        entityId: 'd1',
        op: 'create',
        payload: const <String, dynamic>{},
      );
      for (int i = 0; i < 5; i++) {
        final op = (await outbox.nextBatch()).single;
        await outbox.markFailed(op, 'boom $i');
        if (i < 4) {
          expect(await outbox.nextBatch(), hasLength(1));
        }
      }
      expect(await outbox.nextBatch(), isEmpty);
      final parked = await outbox.watchParked().first;
      expect(parked.single.lastError, 'boom 4');
    });
  });

  group('Repositories (offline write path)', () {
    test('createDoctor stores pending row + outbox op atomically', () async {
      final repo = DoctorRepository(db);
      final String id = await repo.createDoctor(<String, dynamic>{
        'first_name': 'Asha',
        'last_name': 'Rao',
        'doctor_type': 'PRESCRIBER',
      });

      final Doctor? row = await repo.getById(id);
      expect(row, isNotNull);
      expect(row!.localStatus, 'pending_create');
      expect(row.doctorCode, isNull); // PENDING until first push

      final ops = await outbox.nextBatch();
      expect(ops.single.entity, 'doctors');
      expect(ops.single.entityId, id);
      expect(ops.single.op, 'create');
    });

    test('plan create skips local duplicates for same date+customer',
        () async {
      final repo = PlanRepository(db);
      final date = DateTime(2026, 6, 11);
      final first = await repo.createPlans(
        visitDate: date,
        customers: [(customerId: 'c1', customerType: 'doctor')],
      );
      final second = await repo.createPlans(
        visitDate: date,
        customers: [(customerId: 'c1', customerType: 'doctor')],
      );
      expect(first, hasLength(1));
      expect(second, isEmpty);
    });

    test(
        'createDcr enforces one-per-plan, completes the plan and updates '
        'doctor support values (server side effects mirrored)', () async {
      final doctorRepo = DoctorRepository(db);
      final planRepo = PlanRepository(db);
      final dcrRepo = DcrRepository(db);

      final String doctorId =
          await doctorRepo.createDoctor(<String, dynamic>{'first_name': 'A'});
      final plans = await planRepo.createPlans(
        visitDate: DateTime(2026, 6, 11),
        customers: [(customerId: doctorId, customerType: 'doctor')],
      );
      final String planId = plans.single;

      await dcrRepo.createDcr(
        planId: planId,
        supportValue: 1500,
        expectedSupportValue: 2500,
      );

      final DailyPlan? plan = await planRepo.getById(planId);
      expect(plan!.visitStatus, 2); // Completed

      final Doctor? doctor = await doctorRepo.getById(doctorId);
      expect(doctor!.supportValue, 1500);
      expect(doctor.expectedSupportValue, 2500);

      expect(
        () => dcrRepo.createDcr(planId: planId),
        throwsA(isA<StateError>()),
      );
    });

    test('deleting an offline-created chemist leaves no trace', () async {
      final repo = ChemistRepository(db);
      final String id =
          await repo.createChemist(<String, dynamic>{'full_name': 'MedPlus'});
      await repo.deleteChemist(id);

      expect(await repo.getById(id), isNull);
      expect(await outbox.nextBatch(), isEmpty);
    });
  });

  group('KV + device id', () {
    test('deviceId is stable across calls', () async {
      final a = await db.deviceId();
      final b = await db.deviceId();
      expect(a, b);
      expect(a, isNotEmpty);
    });
  });
}
