// import 'dart:convert';
/*
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// import '../../azure.dart';
import '../../data/azureuser/azureuser_network_service.dart';
import '../../data/model/azure_user.dart';
// import '../../data/eyepair/eyepair_network_service.dart';

part 'users_event.dart';
part 'users_state.dart';

class AzureUsersBloc extends Bloc<AzureUsersEvent, AzureUsersState> {
  static const String connectionString =
      'DefaultEndpointsProtocol=https;AccountName=visionscreenerdata;AccountKey=0uJ5hDntTXDyBU/k3VW4xI8s0t+agn1LSZga39J04/Iz2MbCxHOj3/3aeKFKdeacSocW6/vOAD26ilVKYqFYRA==;EndpointSuffix=core.windows.net';
  static const String baseURL =
      'https://visionscreenerdata.table.core.windows.net/dashboardusers';

  AzureUsersBloc() : super(AzureUsersInitial()) {
    on<LoadAzureUsers>(_onLoadAzureUsers);
    // on<AddUsers>(_onAddUsers);
    on<ResetAzureUserToDefault>(_onResetAzureUserToDefault);
    on<UpdateAzureUser>(_onUpdateAzureUser);
    on<InsertAzureUser>(_onInsertAzureUser);
  }
  void _onResetAzureUserToDefault(
      ResetAzureUserToDefault event, Emitter<AzureUsersState> emit) {
    emit(AzureUsersInitial());
  }

  Future<void> _onLoadAzureUsers(
      LoadAzureUsers event, Emitter<AzureUsersState> emit) async {
    emit(
      AzureUsersLoading(),
    );
    try {
      final networkService = AzureuserNetworkService();
      final azureUsers = await networkService.fetchAzureUsers();
      emit(
        AzureUsersLoaded(azureUsers: azureUsers),
      );
    } on Exception catch (e) {
      emit(
        AzureUsersLoadError(e.toString()),
      );
    }
  }

  Future<void> _onUpdateAzureUser(
      UpdateAzureUser event, Emitter<AzureUsersState> emit) async {
    emit(
      AzureUserUpdating(),
    );
    try {
      final networkService = AzureuserNetworkService();
      await networkService.updateAzureUser(event.azureUser);
      emit(
        AzureUserUpdated(),
      );
    } on Exception catch (e) {
      emit(
        AzureUserUpdateError(e.toString()),
      );
    }
  }

  Future<void> _onInsertAzureUser(
      InsertAzureUser event, Emitter<AzureUsersState> emit) async {
        if (event.azureUser == null || event.azureUser!.email.isEmpty) {
          return emit(
        const AzureUserInsertError('Gmail address or Apple ID is required to add dashboard user.'),
      );
        }
    emit(
      AzureUserInserting(),
    );
    try {
      final networkService = AzureuserNetworkService();
      await networkService.insertAzureUser(event.azureUser!);
      emit(
        AzureUserInserted(),
      );
    } on Exception catch (e) {
      emit(
        AzureUserInsertError(e.toString()),
      );
    }
  }
}
*/