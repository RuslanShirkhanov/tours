import 'package:flutter/material.dart';

import 'package:hot_tours/routes/hub.route.dart';

void showRoute<Model>({
  Model? model,
  bool removeUntil = false,
  required BuildContext context,
  required Route<Model?> Function(Model?) builder,
}) =>
    !removeUntil
        ? Navigator.of(context).push<Model?>(builder(model))
        : Navigator.of(context).pushAndRemoveUntil(
            builder(model),
            (route) => route is HubRoute,
          );
