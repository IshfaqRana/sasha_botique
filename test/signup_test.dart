import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sasha_botique/features/auth/domain/usecases/signup_usecase.dart';
import 'package:sasha_botique/features/profile/domain/entities/user.dart';

import 'check_auth_status_test.dart';

void main() {
  late SignupUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignupUseCase(mockRepository);
  });

  final tUser = User(

    email: 'test@example.com',
    firstName: 'Test User', lastName: '', username: '',  mobileNo: '',title: ""
  );
  final tPassword = 'password123';

  test('should call signup method from repository', () async {
    // arrange
    when(mockRepository.signup(tUser, tPassword))
        .thenAnswer((_) async => Future.value());

    // act
    await useCase(tUser, tPassword);

    // assert
    verify(mockRepository.signup(tUser, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw exception when repository fails', () async {
    // arrange
    when(mockRepository.signup(tUser, tPassword))
        .thenThrow(Exception('Email already exists'));

    // act & assert
    expect(() => useCase(tUser, tPassword), throwsException);
    verify(mockRepository.signup(tUser, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });
}