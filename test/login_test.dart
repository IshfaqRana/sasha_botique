import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sasha_botique/features/auth/domain/usecases/login_usecase.dart';

import 'check_auth_status_test.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';

  test('should call login method from repository', () async {
    // arrange
    when(mockRepository.login("test@test.com", "password123"))
        .thenAnswer((_) async => Future.value());

    // act
    await useCase(tEmail, tPassword);

    // assert
    verify(mockRepository.login(tEmail, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw exception when repository fails', () async {
    // arrange
    when(mockRepository.login("test@test.com", "password123"))
        .thenThrow(Exception('Invalid credentials'));

    // act & assert
    expect(() => useCase(tEmail, tPassword), throwsException);
    verify(mockRepository.login(tEmail, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });
}
