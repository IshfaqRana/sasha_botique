import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:sasha_botique/features/auth/domain/repositories/auth_repository.dart';
import 'package:sasha_botique/features/auth/domain/usecases/check_auth_usecase.dart';


@GenerateMocks([AuthRepository])
class MockAuthRepository extends Mock implements AuthRepository {}

// test/domain/usecases/check_auth_status_test.dart


void main() {
  late CheckAuthStatusUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = CheckAuthStatusUseCase(mockRepository);
  });

  test('should return true when user is authenticated', () async {
    // arrange
    when(mockRepository.isAuthenticated()).thenAnswer((_) async => true);

    // act
    final result = await useCase();

    // assert
    expect(result, true);
    verify(mockRepository.isAuthenticated());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return false when user is not authenticated', () async {
    // arrange
    when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);

    // act
    final result = await useCase();

    // assert
    expect(result, false);
    verify(mockRepository.isAuthenticated());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw exception when repository fails', () async {
    // arrange
    when(mockRepository.isAuthenticated()).thenThrow(Exception('Server error'));

    // act & assert
    expect(() => useCase(), throwsException);
    verify(mockRepository.isAuthenticated());
    verifyNoMoreInteractions(mockRepository);
  });
}



