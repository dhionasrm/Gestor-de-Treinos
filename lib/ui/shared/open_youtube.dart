import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/exercise.dart';

Future<void> openExerciseVideo(BuildContext context, Exercise exercise) async {
  final url = exercise.youtubeSearchUrl;
  final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Não foi possível abrir o YouTube.')),
    );
  }
}
