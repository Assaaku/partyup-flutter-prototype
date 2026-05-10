import 'package:flutter_test/flutter_test.dart';
import 'package:partyup_flutter_prototype/app.dart';

void main() {
  testWidgets('PartyUp prototype renders event feed', (tester) async {
    await tester.pumpWidget(const PartyUpApp());
    expect(find.text('Ойролцоох эвентүүд'), findsOneWidget);
    expect(find.text('Нийт эвентүүд'), findsOneWidget);
  });
}
