import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/widgets/bloc/bloc_state_builder.dart';
import 'package:flutter_boilerplate/core/widgets/common/loading_widget.dart';
import 'package:flutter_boilerplate/core/widgets/common/app_error_widget.dart';

/// A wrapper that combines BlocStateBuilder and BlocStateListener
/// for both UI and side effects handling
class BlocStateConsumer<B extends StateStreamable<S>, S extends BlocStateMixin>
    extends StatelessWidget {
  final B? bloc;

  // Builder callbacks
  final Widget Function(BuildContext context, S state) onSuccessBuild;
  final Widget Function(BuildContext context)? onLoadingBuild;
  final Widget Function(BuildContext context, String? message)? onErrorBuild;

  // Listener callbacks
  final void Function(BuildContext context, S state)? onSuccessListen;
  final void Function(BuildContext context, String? message)? onErrorListen;
  final void Function(BuildContext context)? onLoadingListen;

  // Conditions
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;

  const BlocStateConsumer({
    super.key,
    this.bloc,
    required this.onSuccessBuild,
    this.onLoadingBuild,
    this.onErrorBuild,
    this.onSuccessListen,
    this.onErrorListen,
    this.onLoadingListen,
    this.buildWhen,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      bloc: bloc,
      buildWhen: buildWhen,
      listenWhen: listenWhen,
      listener: (context, state) {
        switch (state.status) {
          case BlocStatus.loading:
            onLoadingListen?.call(context);
            break;

          case BlocStatus.error:
            if (onErrorListen != null) {
              onErrorListen!(context, state.errorMessage);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Something went wrong'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            break;

          case BlocStatus.success:
            onSuccessListen?.call(context, state);
            break;

          case BlocStatus.initial:
            break;
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case BlocStatus.initial:
            return const SizedBox.shrink();

          case BlocStatus.loading:
            if (onLoadingBuild != null) {
              return onLoadingBuild!(context);
            }
            return const LoadingWidget();

          case BlocStatus.error:
            if (onErrorBuild != null) {
              return onErrorBuild!(context, state.errorMessage);
            }
            return AppErrorWidget(
              message: state.errorMessage ?? 'Something went wrong',
            );

          case BlocStatus.success:
            return onSuccessBuild(context, state);
        }
      },
    );
  }
}
