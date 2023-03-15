import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_task_loader.dart';
import 'package:frontend/handlers/handlers_time_formatter.dart';
import 'package:frontend/models/model_user_statistics_aggregated.dart';
import 'package:frontend/router.dart';
import 'package:frontend/screens/screen_main.dart';
import 'package:frontend/widgets/widget_main_answers.dart';
import 'package:frontend/widgets/widget_main_task.dart';
import 'package:frontend/widgets/widget_main_timer.dart';
import 'package:frontend/widgets/widget_statistics_chart_success_over_difficulty.dart';
import 'package:frontend/widgets/widget_statistics_chart_time_over_difficulty.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_file.dart';

import '../models/model_game_state.dart';
import '../providers.dart';

class ScreenUserGuide extends ConsumerStatefulWidget {
  const ScreenUserGuide({super.key});

  static String get routeName => 'user_guide';
  static String get routeLocation => '/user_guide';

  final String title = "User Guide";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenUserGuideState();
  }
}

class _ScreenUserGuideState extends ConsumerState<ScreenUserGuide> {
  @override
  Widget build(BuildContext context) {
    var stats = ref.watch(userStatisticsProvider);
    var statsAggregated = aggregateUserStatistics(stats);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: onPressedClose, icon: const Icon(Icons.close)),
          ],
        ),
        body: SingleChildScrollView(
          child: Html(
            data: """<h1>How to Play?</h1>

<p>&nbsp;</p>

<p>This game is based on <strong>ALC description logic</strong>, which is more expressive than propositional logic but less expressive than first order logic.</p>

<p>It will present you the description of a <em>Concept&nbsp;</em>and you have to answer whether it is satisfiable (thumbs up) or not satisfiable (thumbs down).</p>

<p>SCREENSHOT_TODO</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>There are <em>Concepts</em> and <em>Interpretations</em>. <em>Concepts&nbsp;</em>are interpreted as a set of objects. An example&nbsp;<strong><em>concept</em></strong>&nbsp;could be <strong>Animal</strong> and the <strong>interpretation</strong> of Animal would be a set of object instances.</p>

<blockquote>
<p>Concept: Animal</p>

<p>Example Interpretation Animal<sup>I</sup>&nbsp;={ cat_peter, dog_good_boy, lizard_lily, eagle_jason }</p>
</blockquote>

<p><em>Concepts</em>&nbsp;have a name, like in our example the name Animal, or we could also have a&nbsp;<em>concept</em>&nbsp;named Dog or Carnivore or Human or anything else.</p>

<p>&nbsp;</p>

<p>A&nbsp;<strong><em>Concept</em></strong>&nbsp;can also be <strong>defined in relation to other <em>concepts</em></strong>, such as</p>

<blockquote>
<p>Dog&nbsp;&equiv; Animal&nbsp;⊓ Carnivore</p>
</blockquote>

<p>&nbsp;</p>

<p><em>Concepts</em>&nbsp;either are <strong><em>satisfiable</em></strong> or they are not. The&nbsp;<em>concept</em>&nbsp;<strong>Dog </strong>is satisfiable, because we could create an object instance that is both in the set of all Animals and in the set of all Carnivores. The <em>concept</em>&nbsp;<strong>VegetarianDog &equiv; Dog ⊓ </strong>(&not;<strong>Carnivore)</strong>&nbsp;is, however, not satisfiable because it is impossible for an object instance to be both in the set of all carnivores as well as in the set of non-carnivores.</p>

<blockquote>
<p>Animal&nbsp;⊓ Carnivore &nbsp; &nbsp; &nbsp; &nbsp;is satisfiable</p>

<p>VegetarianDog &equiv; Dog ⊓ (&not;Carnivore)&nbsp;&equiv;&nbsp;Animal&nbsp;⊓ Carnivore&nbsp;⊓ (&not;Carnivore) &nbsp; &nbsp; &nbsp; &nbsp;is not satisfiable</p>
</blockquote>

<p>So, in a nutshell, if there is any conflict within the <em>concept</em> and it is impossible to find an object instance that satisfies all parts of the&nbsp;<em>concept</em><em>&nbsp;</em>definition simultaneously, than the&nbsp;<em>concept</em> is not satisfiable.</p>

<p>&nbsp;</p>

<p><strong>Equivalences:</strong></p>

<p>TODOSCREENSHOT</p>
""",
          ),
        ));
  }

  void onPressedClose() {
    context.go(ScreenMain.routeLocation);
    var gameState = ref.watch(gameStateProvider);
    if (!gameState.showSolution) {
      var timerNotifier = ref.watch(timerProvider.notifier);
      timerNotifier.continueTime();
    }
  }
}
