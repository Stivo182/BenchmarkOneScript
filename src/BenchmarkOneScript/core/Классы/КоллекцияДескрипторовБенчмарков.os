#Использовать fluent

Перем _ДескрипторыБенчмарков; // Массив из ДескрипторБенчмарка

// Коллекция дескрипторов бенчмарков
//
// Параметры:
//   ИсточникБенчмарков - Тип, Произвольный - Тип или экземпляр класса бенчмарков
Процедура ПриСозданииОбъекта(ИсточникБенчмарков = Неопределено) Экспорт

	_ДескрипторыБенчмарков = Новый Массив();

	Если Не ИсточникБенчмарков = Неопределено Тогда
		ИзвлекательДескрипторовБенчмарков.Извлечь(ИсточникБенчмарков, ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

// Добавляет дескриптор бенчмарка
//
// Параметры:
//   ДескрипторБенчмарков - ДескрипторБенчмарков
Процедура Добавить(ДескрипторБенчмарков) Экспорт
	
	Если _ДескрипторыБенчмарков.Найти(ДескрипторБенчмарков) = Неопределено Тогда
		_ДескрипторыБенчмарков.Добавить(ДескрипторБенчмарков);
	КонецЕсли;

КонецПроцедуры

// Дескриптор бенчмарка по индексу
//
// Параметры:
//   Индекс - Число - Индекс начиная от 0
//
// Возвращаемое значение:
//   ДескрипторБенчмарка
Функция Получить(Индекс) Экспорт
	Возврат _ДескрипторыБенчмарков[Индекс];
КонецФункции

// Количество дескрипторов бенчмарков
//
// Возвращаемое значение:
//   Число
Функция Количество() Экспорт
	Возврат _ДескрипторыБенчмарков.Количество();
КонецФункции

// Дескриптор бенчмарка по имени метода
//
// Параметры:
//   Имя - Строка - Имя метода бенчмарка
//
// Возвращаемое значение:
//   ДескрипторБенчмарка
Функция НайтиПоИмени(Имя) Экспорт

	Возврат ПроцессорыКоллекций
		.ИзКоллекции(_ДескрипторыБенчмарков)
		.Фильтровать("Элемент -> Элемент.Метод() = """ + Имя + """")
		.ПолучитьПервый();

КонецФункции

// Первый в наборе дескриптор бенчмарка
//
// Возвращаемое значение:
//   ДескрипторБенчмарка
Функция ПолучитьПервый() Экспорт

	Если _ДескрипторыБенчмарков.Количество() > 0 Тогда
		Возврат _ДескрипторыБенчмарков[0];
	КонецЕсли;

КонецФункции

// Создает новую коллекцию из эталонных бенчмарков
//
// Возвращаемое значение:
//   КоллекцияДескрипторовБенчмарков
Функция ПолучитьЭталонные() Экспорт
	Возврат Скопировать().Фильтровать("Бенчмарк -> Бенчмарк.ЭтоЭталон() = Истина");
КонецФункции

// Создает копию коллекции дескрипторов бенчмарков
//
// Возвращаемое значение:
//   КоллекцияДескрипторовБенчмарков
Функция Скопировать() Экспорт

	Коллекция = Новый КоллекцияДескрипторовБенчмарков();

	Для Каждого Бенчмарк Из _ДескрипторыБенчмарков Цикл
		Коллекция.Добавить(Бенчмарк);
	КонецЦикла;

	Возврат Коллекция;

КонецФункции

// Фильтровать коллекцию по условию
//
// Параметры:
//   ФункцияФильтрации - Строка - Лямбда выражение функция с одним параметром в который будет передан элемент,
//     и которая возвращает Булево, Истина если элемент проходит фильтр, Ложь в противном случае
//
// Возвращаемое значение:
//   ЭтотОбъект
Функция Фильтровать(ФункцияФильтрации) Экспорт

	_ДескрипторыБенчмарков = ПроцессорыКоллекций
		.ИзКоллекции(_ДескрипторыБенчмарков)
		.Фильтровать(ФункцияФильтрации)
		.ВМассив();

	Возврат ЭтотОбъект;

КонецФункции

// Массив дескрипторов бенчмарков
//
// Возвращаемое значение:
//   Массив из ДескрипторБенчмарка
Функция ВМассив() Экспорт
	Возврат Новый Массив(Новый ФиксированныйМассив(_ДескрипторыБенчмарков));
КонецФункции