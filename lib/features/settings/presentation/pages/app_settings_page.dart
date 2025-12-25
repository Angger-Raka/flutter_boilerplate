import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:flutter_boilerplate/features/settings/presentation/bloc/bloc.dart';
import 'package:flutter_boilerplate/l10n/generated/app_localizations.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          if (state.status == AppSettingsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AppSettingsStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'An error occurred'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AppSettingsBloc>()
                        .add(const LoadSettings()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle(
                  context, l10n.environment, Icons.cloud_outlined),
              _buildSectionDescription(context, l10n.environmentDescription),
              const SizedBox(height: 8),
              _buildEnvironmentSelector(context, state.settings),
              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.language, Icons.language),
              _buildSectionDescription(context, l10n.languageDescription),
              const SizedBox(height: 8),
              _buildLanguageSelector(context, state.settings),
              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.theme, Icons.palette_outlined),
              _buildSectionDescription(context, l10n.themeDescription),
              const SizedBox(height: 8),
              _buildThemeSelector(context, state.settings),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l10n.restartRequired,
                          style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionDescription(BuildContext context, String description) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Text(description,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }

  Widget _buildEnvironmentSelector(BuildContext context, AppSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final apiUrl = EnvironmentConfig.getBaseUrl(settings.environment);

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<EnvType>(
              initialValue: settings.environment,
              decoration: const InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.zero),
              items: EnvType.values.map((env) {
                String label;
                switch (env) {
                  case EnvType.dev:
                    label = l10n.development;
                    break;
                  case EnvType.staging:
                    label = l10n.staging;
                    break;
                  case EnvType.prod:
                    label = l10n.production;
                    break;
                }
                return DropdownMenuItem(value: env, child: Text(label));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<AppSettingsBloc>().add(ChangeEnvironment(value));
                }
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.link, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'API URL',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        apiUrl,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppSettings settings) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: AppLanguage.supportedLanguages.map((language) {
          final isSelected = settings.language.code == language.code;
          return ListTile(
            title: Text(language.name ?? ''),
            trailing: isSelected
                ? Icon(Icons.check, color: theme.colorScheme.primary)
                : null,
            onTap: () {
              context.read<AppSettingsBloc>().add(ChangeLanguage(language));
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, AppSettings settings) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.systemDefault),
                icon: const Icon(Icons.brightness_auto)),
            ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.lightMode),
                icon: const Icon(Icons.light_mode)),
            ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.darkMode),
                icon: const Icon(Icons.dark_mode)),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (selected) {
            context
                .read<AppSettingsBloc>()
                .add(ChangeThemeMode(selected.first));
          },
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
        ),
      ),
    );
  }
}
