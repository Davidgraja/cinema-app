import 'package:cinemapedia/infrastructure/datasource/isar_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final LocalStorageRepositoryProvider = Provider((ref) => LocalStorageRepositoryimpl(IsarDatasource()));