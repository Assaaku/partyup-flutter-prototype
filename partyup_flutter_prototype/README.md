# PartyUp Flutter Prototype

Монгол хэл дээрх PartyUp эвент удирдлагын frontend prototype.

## Агуулсан модуль

- Бүртгэлгүй хэрэглэгчийн нүүр хэсэг
- Утасны дугаартай хэрэглэгчийн нэвтрэлт: `+976 ********`
- Hard-coded админ нэвтрэлт: `admin / pass`
- 2 баганатай эвентийн feed
- Footer navigation: Эвентүүд, Газрын зураг, Чат, Профайл
- `assets/images/map.png` ашигладаг газрын зурагны дэлгэц
- Эвент дэлгэрэнгүй, нэгдэх, хадгалах mock action
- Эвент үүсгэх prototype
- Админ panel: статистик, moderation, хэрэглэгч/байгууллага/эвент хяналт
- Аюулгүй байдлын тактикийн mock хэрэгжилт: input validation, role guard, rate limit, audit log, privacy-aware error message

## Ажиллуулах

```bash
flutter pub get
flutter run
```

Хэрэв platform folder байхгүй бол:

```bash
flutter create .
flutter pub get
flutter run
```

## Map image

Өөрийн зураг ашиглах бол дараах файлыг солино:

```text
assets/images/map.png
```

## Demo account

```text
Admin username: admin
Admin password: pass
```

Хэрэглэгчийн login хэсэгт дурын нэр, 18-аас дээш нас, 8 оронтой Монгол дугаар оруулж болно.
