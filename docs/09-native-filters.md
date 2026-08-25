# 09. Добавляем Native Filters

Dashboard уже собран. Теперь добавим три общих фильтра и разберём `Scoping` — то есть почему один фильтр может менять все графики, а другой только часть панели.

В итоге на `Учебные продажи` должны быть:

| Имя | Type | Dataset / Column | Scoping |
|---|---|---|---|
| Период | `Time range` | временной диапазон | все 4 графика |
| Регион | `Value` | `sales / region` | все 4 графика |
| Менеджер | `Value` | `sales / manager` | таблица и Big Number |

Перед началом убедитесь, что Dashboard опубликован и без фильтров показывает исходные значения:

```text
общая прибыль = 1530.00
Север: revenue = 1360.00, profit = 520.00
Юг:    revenue = 2645.00, profit = 1010.00
```

## Где настраиваются фильтры

На Dashboard откройте настройки `Filter Bar` через шестерёнку:

```text
Add or edit filters and controls
```

У обычного Native Filter нас интересуют две части:

```text
Settings
Scoping
```

В `Settings` задаём сам фильтр. В `Scoping` решаем, какие Chart должны на него реагировать.

## Период

Добавьте новый фильтр:

```text
Filter name: Период
Filter type: Time range
```

В `Scoping` включите все четыре Chart и сохраните.

Теперь на Dashboard задайте полный февраль 2026 года:

```text
Start (inclusive): 2026-02-01
End (exclusive):   2026-03-01
```

После `Apply filters` ожидается:

```text
общая прибыль = 460.00
```

Таблица:

| region | revenue | profit |
|---|---:|---:|
| Север | 450.00 | 175.00 |
| Юг | 730.00 | 285.00 |

Line Chart должен оставить только:

```text
2026-02 = 1180.00
```

После проверки нажмите:

```text
Clear all
```

## Регион

Добавьте второй фильтр:

```text
Filter name: Регион
Filter type: Value
Dataset:     sales
Column:      region
```

В `Scoping` снова включите все четыре графика.

Проверьте Север:

```text
Регион = Север
```

Ожидается:

```text
общая прибыль = 520.00
выручка Севера = 1360.00
```

Line Chart:

```text
2026-01 = 350.00
2026-02 = 450.00
2026-03 = 560.00
```

Затем проверьте Юг:

```text
общая прибыль = 1010.00
выручка Юга   = 2645.00
```

После этого очистите фильтры.

## Менеджер: здесь нужен Scoping

Третий фильтр:

```text
Filter name: Менеджер
Filter type: Value
Dataset:     sales
Column:      manager
```

Но в `Scoping` включите только:

```text
Продажи по регионам — таблица
Общая прибыль
```

А эти два Chart оставьте вне области действия:

```text
Выручка по регионам — столбцы
Выручка по месяцам
```

Теперь выберите:

```text
Менеджер = Анна
```

Таблица и Big Number должны измениться:

```text
Север → revenue = 750.00, profit = 285.00
Big Number = 285.00
```

А Bar Chart и Line Chart должны сохранить общие значения.

Вот ради этого и нужен `Scoping`: фильтр существует на одном Dashboard, но не обязан влиять на каждый график.

## Проверяем несколько фильтров вместе

Сначала задайте:

```text
Период = февраль 2026
Регион = Север
```

Таблица должна показать:

```text
Север → revenue 450.00, profit 175.00
```

Big Number:

```text
175.00
```

Теперь добавьте:

```text
Менеджер = Анна
```

Таблица и Big Number получают все три условия:

```text
revenue = 180.00
profit  = 70.00
```

Bar Chart и Line Chart не входят в `Scoping` фильтра `Менеджер`, поэтому для них остаются только период и регион:

```text
Bar Chart: Север = 450.00
Line Chart: 2026-02 = 450.00
```

Если все четыре графика внезапно показывают данные Анны, `Scoping` фильтра `Менеджер` настроен неправильно.

В конце нажмите `Clear all`.

## `Apply filters` и `Clear all`

`Apply filters` применяет выбранные значения.

`Clear all` очищает текущий выбор, но не удаляет сами Native Filters с Dashboard.

В горизонтальной ориентации `Filter Bar` кнопка применения может называться просто `Apply`; в курсе ориентацию панели не меняем.

## Фильтр — не право доступа

Это важно не перепутать. Native Filter меняет аналитический запрос, но пользователь может его очистить или выбрать другое значение.

То есть:

```text
Регион = Север
```

не означает, что пользователь получил право видеть только Север.

Разграничение доступа настраивается отдельными механизмами безопасности Superset и источника данных.

## Несколько контрольных проверок

Попробуйте без инструкции получить:

```text
Регион = Юг
→ revenue = 2645.00
→ profit  = 1010.00
```

```text
Период = февраль 2026
→ Север 450.00 / 175.00
→ Юг    730.00 / 285.00
→ Big Number 460.00
```

```text
Менеджер = Клара
→ таблица и Big Number: revenue 1250.00, profit 465.00
→ Bar Chart и Line Chart не меняются
```

## Если фильтр ведёт себя странно

Если он вообще не влияет на Chart, проверьте `Scoping`, а затем не забудьте нажать `Apply filters`.

Если `Value` показывает не те значения, проверьте Dataset и Column:

```text
Регион   → sales.region
Менеджер → sales.manager
```

Если период даёт пустой результат, помните, что учебные данные лежат только в диапазоне:

```text
2026-01-05 … 2026-03-24
```

Для полного февраля используем:

```text
2026-02-01 <= sale_date < 2026-03-01
```

Если после `Менеджер = Анна` меняются все четыре графика, оставьте в `Scoping` менеджера только таблицу и Big Number.

## Что должно остаться на Dashboard

```text
Период   → Time range → все 4 графика
Регион   → Value / sales.region → все 4 графика
Менеджер → Value / sales.manager → таблица + Big Number
```

После `Clear all` исходные значения должны вернуться.

Если понадобится проектировать фильтры уже для другой панели, используйте [справочник по выбору Native Filter и Scoping](09a-choose-native-filter.md).

Следующий урок — первый SQL в SQL Lab.

→ [Урок 10. SQL Lab с нуля](10-sql-lab.md)

## Источники Superset 6.1.0

- меню `Filter Bar` → `Add or edit filters and controls`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FilterBar/FilterBarSettings/index.tsx>
- добавление `Add filter`, типы `Value` и `Time range`, выбор Dataset и Column: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/cypress-base/cypress/e2e/dashboard/utils.ts>
- конфигуратор Native Filters: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FiltersConfigModal/FiltersConfigModal.tsx>
- `Settings` / `Scoping`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FiltersConfigModal/FiltersConfigForm/FiltersConfigForm.tsx>
- кнопки `Cancel` / `Save` окна настройки: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FiltersConfigModal/Footer/Footer.tsx>
- `Apply filters`, `Apply`, `Clear all`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FilterBar/ActionButtons/index.tsx>