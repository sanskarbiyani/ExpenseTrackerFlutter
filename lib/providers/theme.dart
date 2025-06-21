import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ThemeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
