import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/widgets/common/loading_widget.dart';
import 'package:flutter_boilerplate/core/widgets/common/app_error_widget.dart';

/// Enum for common bloc states
enum BlocStatus { initial, loading, success, error }

/// Mixin for states that want to use BlocStateBuilder
mixin BlocStateMixin {
  BlocStatus get status;
  String? get errorMessage;
}

/// A wrapper around BlocBuilder that handles common states
/// (loading, error, success) automatically
class BlocStateBuilder<B extends StateStreamable<S>, S extends BlocStateMixin>
    extends StatelessWidget {
  final B? bloc;
  final Widget Function(BuildContext context, S state) onSuccess;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context, String? message)? onError;
  final Widget Function(BuildContext context, S state)? onInitial;
  final BlocBuilderCondition<S>? buildWhen;

  const BlocStateBuilder({
    super.key,
    this.bloc,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onInitial,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: (context, state) {
        switch (state.status) {
          case BlocStatus.initial:
            if (onInitial != null) {
              return onInitial!(context, state);
            }
            return const SizedBox.shrink();

          case BlocStatus.loading:
            if (onLoading != null) {
              return onLoading!(context);
            }
            return const LoadingWidget();

          case BlocStatus.error:
            if (onError != null) {
              return onError!(context, state.errorMessage);
            }
            return AppErrorWidget(
              message: state.errorMessage ?? 'Something went wrong',
            );

          case BlocStatus.success:
            return onSuccess(context, state);
        }
      },
    );
  }
}
