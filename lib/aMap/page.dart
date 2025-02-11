// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

abstract class AMapExampleAppPage extends StatelessWidget {
  const AMapExampleAppPage(this.leading, this.title, {super.key});

  final Widget leading;
  final String title;
}
