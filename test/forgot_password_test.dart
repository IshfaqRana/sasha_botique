import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sasha_botique/features/auth/domain/usecases/forget_password.dart';

import 'check_auth_status_test.dart';

void main() {
  late ForgotPasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ForgotPasswordUseCase(mockRepository);
  });

  final tEmail = 'test@example.com';

  test('should call sendPasswordResetEmail from repository', () async {
    // arrange
    when(mockRepository.sendPasswordResetEmail(tEmail))
        .thenAnswer((_) async => Future.value());

    // act
    await useCase(tEmail);

    // assert
    verify(mockRepository.sendPasswordResetEmail(tEmail));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw exception when repository fails', () async {
    // arrange
    when(mockRepository.sendPasswordResetEmail(tEmail))
        .thenThrow(Exception('Email not found'));

    // act & assert
    expect(() => useCase(tEmail), throwsException);
    verify(mockRepository.sendPasswordResetEmail(tEmail));
    verifyNoMoreInteractions(mockRepository);
  });
}