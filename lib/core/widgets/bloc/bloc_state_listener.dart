import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/widgets/bloc/bloc_state_builder.dart';

/// A wrapper around BlocListener that handles common side effects
/// (snackbar, navigation, dialog) automatically
class BlocStateListener<B extends StateStreamable<S>, S extends BlocStateMixin>
    extends StatelessWidget {
  final B? bloc;
  final Widget child;
  final void Function(BuildContext context, S state)? onSuccess;
  final void Function(BuildContext context, String? message)? onError;
  final void Function(BuildContext context)? onLoading;
  final BlocListenerCondition<S>? listenWhen;

  const BlocStateListener({
    super.key,
    this.bloc,
    required this.child,
    this.onSuccess,
    this.onError,
    this.onLoading,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      bloc: bloc,
      listenWhen: listenWhen,
      listener: (context, state) {
        switch (state.status) {
          case BlocStatus.loading:
            onLoading?.call(context);
            break;

          case BlocStatus.error:
            if (onError != null) {
              onError!(context, state.errorMessage);
            } else {
              // Default: show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Something went wrong'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            break;

          case BlocStatus.success:
            onSuccess?.call(context, state);
            break;

          case BlocStatus.initial:
            break;
        }
      },
      child: child,
    );
  }
}
