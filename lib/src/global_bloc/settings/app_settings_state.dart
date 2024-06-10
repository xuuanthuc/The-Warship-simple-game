part of 'app_settings_bloc.dart';

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();
}

class AppSettingsInitial extends AppSettingsState {
  @override
  List<Object> get props => [];
}
