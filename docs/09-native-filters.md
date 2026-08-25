# 09. Добавляем Native Filters

## Результат урока

На Dashboard `Учебные продажи` должны появиться три Native Filter:

| Имя | Type | Dataset / Column | Scoping |
|---|---|---|---|
| Период | `Time range` | временной диапазон | все 4 Chart |
| Регион | `Value` | `sales / region` | все 4 Chart |
| Менеджер | `Value` | `sales / manager` | таблица и Big Number |

После урока вы должны уметь применять фильтры, очищать их и ограничивать область действия через `Scoping`.

## Перед началом

Должен быть пройден [урок 08](08-build-dashboard.md).

Откройте:

```text
Dashboards → Учебные продажи
```

Dashboard должен иметь статус:

```text
Published
```

Без активных фильтров контрольные значения:

```text
общая прибыль = 1530.00

Север:
выручка = 1360.00
прибыль = 520.00

Юг:
выручка = 2645.00
прибыль = 1010.00
```

Суммарная выручка по всем данным равна:

```text
1360.00 + 2645.00 = 4005.00
```

Отдельного Big Number `Общая выручка` на учебном Dashboard нет. Выручку проверяем по таблице, Bar Chart и Line Chart.

## Открываем конфигурацию фильтров

В стандартной компоновке курса `Filter Bar` находится слева от Dashboard.

Нажмите значок шестерёнки и выберите:

```text
Add or edit filters and controls
```

Откроется окно конфигурации Native Filters.

Для обычного фильтра используются разделы:

```text
Settings
Scoping
```

В `Settings` задаётся сам фильтр. В `Scoping` выбираются Chart, на которые он действует.

## Фильтр Период

В окне конфигурации нажмите кнопку добавления нового элемента и выберите:

```text
Add filter
```

В `Settings` задайте:

```text
Filter name: Период
Filter type: Time range
```

Перейдите в:

```text
Scoping
```

Включите все четыре Chart:

```text
Продажи по регионам — таблица
Общая прибыль
Выручка по регионам — столбцы
Выручка по месяцам
```

Нажмите:

```text
Save
```

## Проверяем Период

На Dashboard откройте фильтр:

```text
Период
```

Откройте выбор временного диапазона и выберите пользовательский диапазон `Custom`.

Задайте:

```text
Start (inclusive): 2026-02-01
End (exclusive):   2026-03-01
```

То есть фильтр должен охватывать весь февраль 2026 года:

```text
2026-02-01 <= date < 2026-03-01
```

Подтвердите выбранный диапазон и нажмите:

```text
Apply filters
```

В горизонтальной ориентации Filter Bar эта же кнопка имеет короткую подпись `Apply`, но в курсе ориентацию Filter Bar не меняем.

Ожидается:

```text
общая прибыль = 460.00
```

По регионам:

| region | revenue | profit |
|---|---:|---:|
| Север | 450.00 | 175.00 |
| Юг | 730.00 | 285.00 |

Суммарная выручка по двум строкам таблицы:

```text
450.00 + 730.00 = 1180.00
```

Bar Chart должен показать те же две суммы по регионам, а временной Chart:

```text
2026-02 = 1180.00
```

Нажмите:

```text
Clear all
```

и проверьте возврат к исходным значениям.

## Фильтр Регион

Снова откройте:

```text
Filter Bar → шестерёнка → Add or edit filters and controls
```

Добавьте:

```text
Add filter
```

В `Settings` задайте:

```text
Filter name: Регион
Filter type: Value
Dataset:     sales
Column:      region
```

В `Scoping` включите все четыре Chart.

Нажмите `Save`.

## Проверяем Регион

На Dashboard выберите:

```text
Регион = Север
```

Нажмите `Apply filters`.

Ожидается:

```text
общая прибыль = 520.00
```

Таблица должна оставить строку:

| region | revenue | profit |
|---|---:|---:|
| Север | 1360.00 | 520.00 |

В этой строке и в Bar Chart видна выручка:

```text
Север = 1360.00
```

Line Chart:

```text
2026-01 = 350.00
2026-02 = 450.00
2026-03 = 560.00
```

Теперь выберите:

```text
Регион = Юг
```

и примените фильтры.

Ожидается:

```text
общая прибыль = 1010.00
```

Выручка в таблице и Bar Chart:

```text
Юг = 2645.00
```

После проверки нажмите `Clear all`.

## Фильтр Менеджер

Откройте конфигурацию фильтров и добавьте ещё один `Add filter`.

В `Settings` задайте:

```text
Filter name: Менеджер
Filter type: Value
Dataset:     sales
Column:      manager
```

В учебных данных доступны непустые значения:

```text
Анна
Борис
Клара
Денис
```

Откройте `Scoping`.

Включите только:

```text
Продажи по регионам — таблица
Общая прибыль
```

Не включайте:

```text
Выручка по регионам — столбцы
Выручка по месяцам
```

Нажмите `Save`.

## Проверяем Scoping

Убедитесь, что остальные фильтры очищены.

Выберите:

```text
Менеджер = Анна
```

Нажмите `Apply filters`.

Chart внутри Scoping должны измениться.

Таблица:

| region | revenue | profit |
|---|---:|---:|
| Север | 750.00 | 285.00 |

Big Number:

```text
285.00
```

Chart вне Scoping должны остаться без фильтра `Менеджер`:

```text
Bar Chart:
Север = 1360.00
Юг    = 2645.00

Line Chart:
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

Нажмите `Clear all`.

## Несколько фильтров одновременно

Установите:

```text
Период = февраль 2026
Регион = Север
```

Для `Период` используйте тот же диапазон `Custom`:

```text
Start (inclusive): 2026-02-01
End (exclusive):   2026-03-01
```

`Менеджер` оставьте пустым.

Нажмите `Apply filters`.

Ожидается:

```text
таблица:
Север → revenue 450.00, profit 175.00

Big Number:
175.00
```

Теперь дополнительно выберите:

```text
Менеджер = Анна
```

и снова примените фильтры.

Таблица и Big Number получают все три условия:

```text
Период + Регион + Менеджер
```

Ожидается:

```text
таблица:
Север → revenue 180.00, profit 70.00

Big Number:
70.00
```

Bar Chart и Line Chart не входят в Scoping фильтра `Менеджер`, поэтому продолжают учитывать только период и регион:

```text
Bar Chart:
Север = 450.00

Line Chart:
2026-02 = 450.00
```

После проверки нажмите:

```text
Clear all
```

## Apply filters и Clear all

После изменения значений нажимайте:

```text
Apply filters
```

`Clear all` удаляет текущие выбранные значения фильтров, но не удаляет сами Native Filters с Dashboard.

## Native Filter и права доступа

Native Filter изменяет условия аналитического запроса для Chart в его Scoping.

Например:

```text
Регион = Север
```

не ограничивает права пользователя только Севером. Пользователь может очистить фильтр или выбрать другое значение.

Ограничения доступа к данным настраиваются отдельными механизмами безопасности Superset и в этот базовый урок не входят.

## Самостоятельная проверка

### Регион = Юг

Ожидается:

```text
таблица: revenue = 2645.00, profit = 1010.00
Big Number: 1010.00
```

### Период = февраль 2026

Ожидается:

```text
таблица: Север 450.00 / 175.00, Юг 730.00 / 285.00
Big Number: 460.00
Line Chart: 2026-02 = 1180.00
```

### Период = февраль 2026, Регион = Юг

Ожидается:

```text
таблица: Юг → revenue 730.00, profit 285.00
Big Number: 285.00
```

### Менеджер = Клара

Для таблицы и Big Number:

```text
выручка = 1250.00
прибыль = 465.00
```

Bar Chart и Line Chart должны сохранить общие значения, потому что не входят в Scoping фильтра `Менеджер`.

## Типовые ошибки

### Фильтр не меняет Chart

Проверьте:

```text
Scoping
```

и затем нажмите:

```text
Apply filters
```

### Value показывает не тот набор значений

Проверьте:

```text
Регион:
Dataset = sales
Column  = region

Менеджер:
Dataset = sales
Column  = manager
```

### Период даёт пустой результат

Учебные данные находятся в диапазоне:

```text
2026-01-05 … 2026-03-24
```

Для проверки февраля используйте:

```text
Start (inclusive): 2026-02-01
End (exclusive):   2026-03-01
```

### После Менеджер = Анна изменились все четыре Chart

Откройте `Scoping` фильтра `Менеджер` и оставьте только таблицу и Big Number.

## Критерий завершения

На Dashboard должны существовать:

```text
Период   → Time range → все 4 Chart
Регион   → Value / sales.region → все 4 Chart
Менеджер → Value / sales.manager → таблица + Big Number
```

Перед завершением нажмите `Clear all`.

Исходные значения должны восстановиться:

```text
общая прибыль = 1530.00

таблица:
Север → revenue 1360.00, profit 520.00
Юг    → revenue 2645.00, profit 1010.00
```

Суммарная выручка по таблице:

```text
4005.00
```

## Справочник к уроку

Если нужно выбрать тип Native Filter для другого Dashboard, продумать Scoping или понять, почему один Filter не должен влиять на все Chart:

→ [Как выбрать Native Filter](09a-choose-native-filter.md)

Следующий урок — SQL Lab.

→ [Урок 10. SQL Lab с нуля](10-sql-lab.md)

## Источники Superset 6.1.0

- меню Filter Bar `Add or edit filters and controls`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FilterBar/FilterBarSettings/index.tsx>
- добавление `Add filter`, типы `Value` и `Time range`, выбор Dataset и Column: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/cypress-base/cypress/e2e/dashboard/utils.ts>
- конфигуратор Native Filters: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FiltersConfigModal/FiltersConfigModal.tsx>
- `Settings` / `Scoping`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FiltersConfigModal/FiltersConfigForm/FiltersConfigForm.tsx>
- кнопки `Cancel` / `Save` окна настройки: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FiltersConfigModal/Footer/Footer.tsx>
- `Apply filters`, `Apply`, `Clear all`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/dashboard/components/nativeFilters/FilterBar/ActionButtons/index.tsx>
