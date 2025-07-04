#Использовать delegate

// Создает экземпляр колонки
//
// Возвращаемое значение:
//   КолонкаОтчетаБенчмарков
Функция Создать() Экспорт
	
	Колонка = Новый КолонкаОтчетаБенчмарков(КолонкиОтчетаБенчмарков.ВыделяемаяПамять);
	Колонка.Заголовок = "Allocated";
	Колонка.Описание = "Выделяемая память на одну операцию";
	Колонка.ЕдиницаИзмерения = ЕдиницыИзмеренийБенчмарков.Байт;
	Колонка.ЭтоЧисло = Истина;
	Колонка.ЗначениеДелегат = Делегаты.Создать(ЭтотОбъект, "Значение");

	Возврат Колонка;

КонецФункции

// Возвращает значение колонки
//
// Параметры:
//   СтрокаРезультата - СтрокаТаблицыЗначений - см. МенеджерРасшифровкиРезультатовБенчмарков.НоваяТаблицаРасшифровки
//   Колонка - КолонкаОтчетаБенчмарков
//
// Возвращаемое значение:
//   Произвольный
Функция Значение(СтрокаРезультата, Колонка) Экспорт // BSLLS:UnusedParameters-off

	Возврат СтрокаРезультата.Статистика.ВыделяемаяПамять;

КонецФункции